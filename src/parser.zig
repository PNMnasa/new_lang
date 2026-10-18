const std = @import("std");
const token = @import("token.zig");
const ast = @import("ast.zig");

const Token = token.Token;
const TokenKind = token.TokenKind;
const Type = ast.Type;
const Expr = ast.Expr;
const Stmt = ast.Stmt;
const FnDef = ast.FnDef;
const Program = ast.Program;

pub const ParseError = error{
    ExpectedToken,
    ExpectedType,
    ParseInt,
    UnexpectedToken,
    UnexpectedStmt,
    OutOfMemory,
};

pub const Parser = struct {
    tokens: []Token,
    pos: usize,
    arena: *std.heap.ArenaAllocator,

    fn peek(self: Parser) Token {
        if (self.pos >= self.tokens.len) return Token{ .kind = .eof, .text = "", .line = 0 };
        return self.tokens[self.pos];
    }

    fn advance(self: *Parser) Token {
        const t = self.peek();
        self.pos += 1;
        return t;
    }

    fn expect(self: *Parser, kind: TokenKind) ParseError!Token {
        const t = self.peek();
        if (t.kind != kind) return error.ExpectedToken;
        _ = self.advance();
        return t;
    }

    fn parseType(self: *Parser) ParseError!Type {
        const t = self.peek();
        return switch (t.kind) {
            .kw_i32 => {
                _ = self.advance();
                return .i32;
            },
            .kw_i64 => {
                _ = self.advance();
                return .i64;
            },
            .kw_void => {
                _ = self.advance();
                return .void;
            },
            else => return error.ExpectedType,
        };
    }

    fn parseExpr(self: *Parser) ParseError!*Expr {
        var lhs = try self.parseTerm();
        while (true) {
            const op = self.peek().kind;
            if (op != .plus and op != .minus) break;
            _ = self.advance();
            const rhs = try self.parseTerm();
            const node = try self.arena.allocator().create(Expr);
            node.* = .{ .binop = .{ .op = op, .lhs = lhs, .rhs = rhs } };
            lhs = node;
        }
        return lhs;
    }

    fn parseTerm(self: *Parser) ParseError!*Expr {
        var lhs = try self.parsePrimary();
        while (true) {
            const op = self.peek().kind;
            if (op != .star and op != .slash) break;
            _ = self.advance();
            const rhs = try self.parsePrimary();
            const node = try self.arena.allocator().create(Expr);
            node.* = .{ .binop = .{ .op = op, .lhs = lhs, .rhs = rhs } };
            lhs = node;
        }
        return lhs;
    }

    fn parsePrimary(self: *Parser) ParseError!*Expr {
        const t = self.peek();
        if (t.kind == .int_lit) {
            _ = self.advance();
            const val = std.fmt.parseInt(i64, t.text, 10) catch return error.ParseInt;
            const node = try self.arena.allocator().create(Expr);
            node.* = .{ .int = val };
            return node;
        }
        if (t.kind == .ident) {
            _ = self.advance();
            const node = try self.arena.allocator().create(Expr);
            node.* = .{ .var_ref = t.text };
            return node;
        }
        if (t.kind == .lparen) {
            _ = self.advance();
            const e = try self.parseExpr();
            _ = try self.expect(.rparen);
            return e;
        }
        return error.UnexpectedToken;
    }

    fn parseStmt(self: *Parser) ParseError!*Stmt {
        const t = self.peek();
        if (t.kind == .kw_let) {
            _ = self.advance();
            const name_tok = try self.expect(.ident);
            _ = try self.expect(.colon);
            const ty = try self.parseType();
            _ = try self.expect(.assign);
            const init = try self.parseExpr();
            _ = try self.expect(.semi);
            const node = try self.arena.allocator().create(Stmt);
            node.* = .{ .decl = .{ .name = name_tok.text, .ty = ty, .init = init } };
            return node;
        }
        if (t.kind == .kw_return) {
            _ = self.advance();
            const e = try self.parseExpr();
            _ = try self.expect(.semi);
            const node = try self.arena.allocator().create(Stmt);
            node.* = .{ .ret = e };
            return node;
        }
        return error.UnexpectedStmt;
    }

    fn parseFn(self: *Parser) ParseError!*FnDef {
        _ = try self.expect(.kw_fn);
        const name_tok = try self.expect(.ident);
        _ = try self.expect(.lparen);
        _ = try self.expect(.rparen);
        _ = try self.expect(.arrow);
        const ret_ty = try self.parseType();
        _ = try self.expect(.lbrace);

        var body: std.ArrayList(*Stmt) = .empty;
        defer body.deinit(self.arena.allocator());
        while (self.peek().kind != .rbrace and self.peek().kind != .eof) {
            try body.append(self.arena.allocator(), try self.parseStmt());
        }
        _ = try self.expect(.rbrace);

        const fn_node = try self.arena.allocator().create(FnDef);
        fn_node.* = FnDef{
            .name = name_tok.text,
            .ret_ty = ret_ty,
            .body = try body.toOwnedSlice(self.arena.allocator()),
        };
        return fn_node;
    }

    pub fn parseProgram(self: *Parser) ParseError!Program {
        var fns: std.ArrayList(*FnDef) = .empty;
        defer fns.deinit(self.arena.allocator());
        while (self.peek().kind != .eof) {
            try fns.append(self.arena.allocator(), try self.parseFn());
        }
        return Program{ .fns = try fns.toOwnedSlice(self.arena.allocator()) };
    }
};
