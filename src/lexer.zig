const std = @import("std");
const token = @import("token.zig");
const diagnostics = @import("diagnostics.zig");

const Token = token.Token;
const TokenKind = token.TokenKind;

pub const Lexer = struct {
    src: []const u8,
    pos: usize,
    line: usize,

    pub fn init(src: []const u8) Lexer {
        return Lexer{ .src = src, .pos = 0, .line = 1 };
    }

    fn peek(self: Lexer) u8 {
        if (self.pos >= self.src.len) return 0;
        return self.src[self.pos];
    }

    fn next(self: *Lexer) u8 {
        const c = self.peek();
        if (c == '\n') self.line += 1;
        if (c != 0) self.pos += 1;
        return c;
    }

    fn peekAhead(self: Lexer, n: usize) u8 {
        if (self.pos + n >= self.src.len) return 0;
        return self.src[self.pos + n];
    }

    fn skipWhitespace(self: *Lexer) void {
        while (true) {
            const c = self.peek();
            if (c == ' ' or c == '\t' or c == '\r' or c == '\n') {
                _ = self.next();
            } else if (c == '/' and self.peekAhead(1) == '/') {
                while (true) {
                    const c2 = self.peek();
                    if (c2 == '\n' or c2 == 0) break;
                    _ = self.next();
                }
            } else {
                break;
            }
        }
    }

    pub fn nextToken(self: *Lexer) Token {
        self.skipWhitespace();
        const line = self.line;
        const start = self.pos;
        const c = self.peek();

        if (c == 0) return Token{ .kind = .eof, .text = "", .line = line };

        if (c == ';') {
            _ = self.next();
            return Token{ .kind = .semi, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == '(') {
            _ = self.next();
            return Token{ .kind = .lparen, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == ')') {
            _ = self.next();
            return Token{ .kind = .rparen, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == '{') {
            _ = self.next();
            return Token{ .kind = .lbrace, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == '}') {
            _ = self.next();
            return Token{ .kind = .rbrace, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == '=') {
            _ = self.next();
            return Token{ .kind = .assign, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == '+') {
            _ = self.next();
            return Token{ .kind = .plus, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == '*') {
            _ = self.next();
            return Token{ .kind = .star, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == '/') {
            _ = self.next();
            return Token{ .kind = .slash, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == ':') {
            _ = self.next();
            return Token{ .kind = .colon, .text = self.src[start .. start + 1], .line = line };
        }
        if (c == ',') {
            _ = self.next();
            return Token{ .kind = .comma, .text = self.src[start .. start + 1], .line = line };
        }

        if (c == '-' and self.peekAhead(1) == '>') {
            _ = self.next();
            _ = self.next();
            return Token{ .kind = .arrow, .text = self.src[start .. start + 2], .line = line };
        }
        if (c == '-') {
            _ = self.next();
            return Token{ .kind = .minus, .text = self.src[start .. start + 1], .line = line };
        }

        if (c >= '0' and c <= '9') {
            while (self.peek() >= '0' and self.peek() <= '9') _ = self.next();
            return Token{ .kind = .int_lit, .text = self.src[start..self.pos], .line = line };
        }

        if ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '_') {
            while ((self.peek() >= 'a' and self.peek() <= 'z') or (self.peek() >= 'A' and self.peek() <= 'Z') or (self.peek() >= '0' and self.peek() <= '9') or self.peek() == '_') {
                _ = self.next();
            }
            const text = self.src[start..self.pos];
            if (token.lookupKeyword(text)) |kind| {
                return Token{ .kind = kind, .text = text, .line = line };
            }
            return Token{ .kind = .ident, .text = text, .line = line };
        }

        diagnostics.unexpectedCharacter(c, line);
        return Token{ .kind = .eof, .text = "", .line = line };
    }
};
