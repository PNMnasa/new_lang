const std = @import("std");

pub fn unexpectedCharacter(c: u8, line: usize) void {
    std.debug.print("error: unexpected character '{c}' at line {d}\n", .{ c, line });
}

pub fn usage() void {
    std.debug.print("Usage: modernass build [--debug-mode] <file1> [file2 ...] [--debug]\n", .{});
}

pub fn wroteOutput(path: []const u8, bytes: usize) void {
    std.debug.print("wrote {s} ({d} bytes)\n", .{ path, bytes });
}
