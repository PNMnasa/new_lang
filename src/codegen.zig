const std = @import("std");
const ast = @import("ast.zig");

const Allocator = std.mem.Allocator;
const Type = ast.Type;
const Expr = ast.Expr;
const FnDef = ast.FnDef;
const Program = ast.Program;

const VarInfo = struct {
    name: []const u8,
    ty: Type,
    alloca_reg: usize,
};

pub const Codegen = struct {
    gpa: Allocator,
    out: std.ArrayList(u8),
    arena: *std.heap.ArenaAllocator,
    reg: usize,
    vars: []VarInfo,

    pub fn init(allocator: Allocator, arena: *std.heap.ArenaAllocator) Codegen {
        return Codegen{
            .gpa = allocator,
            .out = .empty,
            .arena = arena,
            .reg = 0,
            .vars = &[_]VarInfo{},
        };
    }

    pub fn deinit(self: *Codegen) void {
        self.out.deinit(self.gpa);
    }

    fn nextReg(self: *Codegen) usize {
        self.reg += 1;
        return self.reg - 1;
    }

    fn write(self: *Codegen, comptime fmt: []const u8, args: anytype) !void {
        const s = try std.fmt.allocPrint(self.gpa, fmt, args);
        defer self.gpa.free(s);
        try self.out.appendSlice(self.gpa, s);
    }

    fn typeLlvm(t: Type) []const u8 {
        return switch (t) {
            .i32 => "i32",
            .i64 => "i64",
            .void => "void",
        };
    }

    fn findVar(self: Codegen, name: []const u8) ?usize {
        var i: usize = 0;
        for (self.vars) |v| {
            if (std.mem.eql(u8, v.name, name)) return i;
            i += 1;
        }
        return null;
    }

    fn genExpr(self: *Codegen, e: *Expr) !usize {
        return switch (e.*) {
            .int => |val| {
                const r = self.nextReg();
                try self.write("{d} = add i32 0, {d}\n", .{ r, val });
                return r;
            },
            .var_ref => |name| {
                const idx = self.findVar(name) orelse return error.UndefinedVar;
                const v = self.vars[idx];
                const r = self.nextReg();
                try self.write("{d} = load {s}, ptr {d}\n", .{ r, typeLlvm(v.ty), v.alloca_reg });
                return r;
            },
            .binop => |b| {
                const l = try self.genExpr(b.lhs);
                const r = try self.genExpr(b.rhs);
                const out = self.nextReg();
                const op = switch (b.op) {
                    .plus => "add",
                    .minus => "sub",
                    .star => "mul",
                    .slash => "sdiv",
                    else => return error.UnsupportedOp,
                };
                try self.write("{d} = {s} i32 {d}, {d}\n", .{ out, op, l, r });
                return out;
            },
        };
    }

    fn genFunction(self: *Codegen, fndef: *FnDef) !void {
        try self.write("define {s} @{s}() {{\n", .{ typeLlvm(fndef.ret_ty), fndef.name });
        try self.write("entry:\n", .{});

        self.vars = &[_]VarInfo{};

        for (fndef.body) |stmt| {
            switch (stmt.*) {
                .decl => |d| {
                    const alloca = self.nextReg();
                    try self.write("{d} = alloca {s}\n", .{ alloca, typeLlvm(d.ty) });
                    const init_reg = try self.genExpr(d.init);
                    try self.write("store {s} {d}, ptr {d}\n", .{ typeLlvm(d.ty), init_reg, alloca });
                    const new_vars = self.arena.allocator().alloc(VarInfo, self.vars.len + 1) catch |err| return err;
                    std.mem.copyForwards(VarInfo, new_vars, self.vars);
                    new_vars[new_vars.len - 1] = VarInfo{ .name = d.name, .ty = d.ty, .alloca_reg = alloca };
                    self.vars = new_vars;
                },
                .ret => |e| {
                    const r = try self.genExpr(e);
                    try self.write("ret {s} {d}\n", .{ typeLlvm(fndef.ret_ty), r });
                },
            }
        }

        try self.write("}}\n\n", .{});
    }

    pub fn genProgram(self: *Codegen, prog: Program) !void {
        for (prog.fns) |fndef| {
            try self.genFunction(fndef);
        }
    }

    pub fn buildOutput(self: *Codegen) ![]const u8 {
        return try self.out.toOwnedSlice(self.gpa);
    }
};
