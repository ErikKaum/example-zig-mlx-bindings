const std = @import("std");
const c = @cImport({
    @cInclude("mlx/c/error.h");
});

/// Common error type for MLX operations
pub const MLXError = error{
    DeviceError,
    StringError,
    // Add other specific errors as needed
};

/// Type definition for the error handler function
pub const ErrorHandlerFn = *const fn (msg: [*:0]const u8, data: ?*anyopaque) void;

/// Set a custom error handler for MLX errors
pub fn setErrorHandler(
    handler: ErrorHandlerFn,
    data: ?*anyopaque,
    dtor: ?*const fn (*anyopaque) void,
) void {
    c.mlx_set_error_handler(
        @ptrCast(handler),
        data,
        @ptrCast(dtor),
    );
}

/// Default error handler that captures the last error message
var last_error_msg: ?[]const u8 = null;

fn defaultErrorHandler(msg: [*:0]const u8, data: ?*anyopaque) callconv(.C) void {
    _ = data;
    last_error_msg = std.mem.span(msg);
}

/// Initialize the default error handler
pub fn init() void {
    setErrorHandler(defaultErrorHandler, null, null);
}

/// Get the last error message if any
pub fn getLastError() ?[]const u8 {
    return last_error_msg;
}
