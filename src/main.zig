const std = @import("std");
// const Lexer = @import("lexer.zig").Lexer;
// const Parser = @import("parser.zig").Parser;
// const Codegen = @import("codegen.zig").Codegen;
// const Token = @import("token.zig").Token;
// const diagnostics = @import("diagnostics.zig");

// pub const BuildFlags = struct {
//     debug_mode: bool = false,
// };

// pub const BuildError = error{ NoInputFiles, UnknownFlag, StreamTooLong, InputOutput, ConnectionResetByPeer, NotOpenForReading, SocketUnconnected, LockViolation, ExpectedToken, ExpectedType, ParseInt, UnexpectedToken, UnexpectedStmt, UndefinedVar, UnsupportedOp, DiskQuota, BrokenPipe, NotOpenForWriting } || std.process.Args.Iterator.InitError || std.Io.Reader.Error || std.Io.File.OpenError || std.mem.Allocator.Error;

// fn isFlag(arg: []const u8) bool {
//     return std.mem.startsWith(u8, arg, "-");
// }

// fn parseFlagsAndInputs(args: []const []const u8) BuildError!struct { flags: BuildFlags, files: [][]const u8 } {
//     var flags = BuildFlags{};
//     var files: std.ArrayList([]const u8) = .empty;
//     defer files.deinit(std.heap.page_allocator);

//     var i: usize = 1;
//     while (i < args.len) {
//         const a = args[i];
//         if (std.mem.eql(u8, a, "--debug-mode")) {
//             flags.debug_mode = true;
//             i += 1;
//             continue;
//         }
//         if (std.mem.eql(u8, a, "--debug")) {
//             flags.debug_mode = true;
//             i += 1;
//             continue;
//         }
//         if (isFlag(a)) {
//             return BuildError.UnknownFlag;
//         }
//         try files.append(std.heap.page_allocator, a);
//         i += 1;
//     }

//     if (files.items.len == 0) return BuildError.NoInputFiles;
//     const owned = try files.toOwnedSlice(std.heap.page_allocator);
//     return .{ .flags = flags, .files = owned };
// }

// fn buildFiles(allocator: std.mem.Allocator, io: std.Io, cwd: std.Io.Dir, files: [][]const u8, flags: BuildFlags) BuildError!void {
//     for (files) |file| {
//         const source = try cwd.readFileAlloc(io, file, allocator, .limited(1024 * 1024));
//         defer allocator.free(source);

//         var arena = std.heap.ArenaAllocator.init(allocator);
//         defer arena.deinit();
//         const arena_alloc = arena.allocator();

//         var lexer = Lexer.init(source);
//         var token_list: std.ArrayList(Token) = .empty;
//         defer token_list.deinit(arena_alloc);
//         while (true) {
//             const tok = lexer.nextToken();
//             try token_list.append(arena_alloc, tok);
//             if (tok.kind == .eof) break;
//         }

//         var parser = Parser{ .tokens = token_list.items, .pos = 0, .arena = &arena };
//         const program = try parser.parseProgram();

//         var cg = Codegen.init(arena_alloc, &arena);
//         defer cg.deinit();
//         try cg.genProgram(program);
//         const llvm_ir = try cg.buildOutput();

//         const base = std.fs.path.basename(file);
//         var out_name_buf: [256]u8 = undefined;
//         const out_name = try std.fmt.bufPrint(&out_name_buf, "{s}.ll", .{base});
//         try cwd.writeFile(io, .{ .sub_path = out_name, .data = llvm_ir });
//         std.debug.print("wrote {s} ({d} bytes)\n", .{ out_name, llvm_ir.len });
//     }
//     _ = flags;
// }

pub fn main(init: std.process.Init) !void {
    std.debug.print("{}", init.preopens.map);
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const allocator = arena.allocator();

    // var args_list: std.ArrayList([]const u8) = .empty;
    // defer args_list.deinit(allocator);
    // var args_it = std.process.Args.iterateAllocator(init.minimal.args, allocator) catch return;
    // defer args_it.deinit();
    // while (args_it.next()) |a| {
    //     try args_list.append(allocator, a);
    // }
    // const args = args_list.items;

    // if (args.len < 2) {
    //     diagnostics.usage();
    //     return;
    // }

    // const parsed = parseFlagsAndInputs(args) catch |err| switch (err) {
    //     BuildError.NoInputFiles => {
    //         diagnostics.usage();
    //         return;
    //     },
    //     BuildError.UnknownFlag => {
    //         diagnostics.usage();
    //         return;
    //     },
    //     else => return err,
    // };

    // const cwd = std.Io.Dir.cwd();
    // try buildFiles(allocator, init.io, cwd, parsed.files, parsed.flags);
}
