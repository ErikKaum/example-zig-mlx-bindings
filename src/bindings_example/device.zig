const std = @import("std");

const c = @cImport({
    @cInclude("mlx/c/device.h");
    @cInclude("mlx/c/error.h");
});

const mlx_error = @import("error.zig");
const string = @import("string.zig");

pub const DeviceType = enum(c_uint) {
    cpu = c.MLX_CPU,
    gpu = c.MLX_GPU,
};

pub const Device = struct {
    inner: c.mlx_device,

    ///  Returns a new empty device.
    pub fn init() Device {
        return .{ .inner = c.mlx_device_new() };
    }

    /// Returns a new device of specified `type`, with specified `index`.
    pub fn initNewType(device_type: DeviceType, index: i32) Device {
        return .{ .inner = c.mlx_device_new_type(@intFromEnum(device_type), index) };
    }

    /// Calls free on the device
    // pub fn deinit(self: *Device) anyerror!void {
    //     if (c.mlx_device_free(self.inner) != 0) {
    //         return 1;
    //     }
    // }

    /// Device descprition
    pub fn toString(self: Device) mlx_error.MLXError!string.String {
        var str = string.String.init();
        errdefer str.deinit() catch {};

        if (c.mlx_device_tostring(@ptrCast(&str.inner), self.inner) != 0) {
            return mlx_error.MLXError.DeviceError;
        }

        return str;
    }
};

pub fn deinit(device: *const Device) mlx_error.MLXError!void {
    if (c.mlx_device_free(device.inner) != 0) {
        // Can access the error message if needed
        if (mlx_error.getLastError()) |msg| {
            std.log.err("MLX error: {s}", .{msg});
        }
        return mlx_error.MLXError.DeviceError;
    }
}
