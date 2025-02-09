const std = @import("std");

const c = @cImport(@cInclude("mlx/c/string.h"));

const mlx_error = @import("error.zig");

pub const String = struct {
    inner: c.mlx_string,

    /// Returns a new empty string
    pub fn init() String {
        return .{ .inner = c.mlx_string_new() };
    }

    /// Returns a new string from a null-terminated string
    pub fn initFromCStr(str: [*:0]const u8) String {
        return .{ .inner = c.mlx_string_new_data(str) };
    }

    /// Set string to src string
    pub fn set(self: *String, src: String) mlx_error.MLXError!void {
        if (c.mlx_string_set(&self.inner, src.inner) != 0) {
            return mlx_error.MLXError.StringError;
        }
    }

    /// Returns a pointer to the string contents
    pub fn data(self: String) [*:0]const u8 {
        return c.mlx_string_data(self.inner);
    }

    /// Free the string
    pub fn deinit(self: *const String) mlx_error.MLXError!void {
        if (c.mlx_string_free(self.inner) != 0) {
            return mlx_error.MLXError.StringError;
        }
    }

    pub fn format(
        self: String,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.writeAll(std.mem.span(self.data()));
    }
};
