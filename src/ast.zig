const token = @import("token.zig");

pub const Type = enum { i32, i64, void };

pub fn typeName(t: Type) []const u8 {
    return switch (t) {
        .i32 => "i32",
        .i64 => "i64",
        .void => "void",
    };
}

pub const Expr = union(enum) {
    int: i64,
    var_ref: []const u8,
    binop: struct {
        op: token.TokenKind,
        lhs: *Expr,
        rhs: *Expr,
    },
};

pub const Stmt = union(enum) {
    decl: struct {
        name: []const u8,
        ty: Type,
        init: *Expr,
    },
    ret: *Expr,
};

pub const FnDef = struct {
    name: []const u8,
    ret_ty: Type,
    body: []*Stmt,
};

pub const Program = struct {
    fns: []*FnDef,
};
