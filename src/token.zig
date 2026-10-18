const std = @import("std");

pub const TokenKind = enum {
    eof, // end of file
    ident, // identifier
    int_lit, // integer literal
    kw_fn, // keyword: fn
    kw_let, // keyword: let
    kw_return, // keyword: return
    kw_i32, // keyword: i32
    kw_i64, // keyword: i64
    kw_void, // keyword: void
    semi, // ;
    lparen, // (
    rparen, // )
    lbrace, // {
    rbrace, // }
    assign, // =
    arrow, // =>
    colon, // :
    comma, // ,
    plus, // +
    minus, // -
    star, // *
    slash, // /
};

pub const Token = struct {
    kind: TokenKind,
    text: []const u8,
    line: usize,
};

pub const Keyword = struct {
    text: []const u8,
    kind: TokenKind,
};

pub const keywords = [_]Keyword{
    Keyword{ .text = "fn", .kind = .kw_fn },
    Keyword{ .text = "let", .kind = .kw_let },
    Keyword{ .text = "return", .kind = .kw_return },
    Keyword{ .text = "i32", .kind = .kw_i32 },
    Keyword{ .text = "i64", .kind = .kw_i64 },
    Keyword{ .text = "void", .kind = .kw_void },
};

pub fn lookupKeyword(text: []const u8) ?TokenKind {
    for (keywords) |kw| {
        if (std.mem.eql(u8, text, kw.text)) return kw.kind;
    }
    return null;
}
