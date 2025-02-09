const std = @import("std");
const device = @import("device.zig");

pub fn main() !void {
    const d = device.Device.initNewType(device.DeviceType.cpu, 0);

    const d_string = try d.toString();
    defer d_string.deinit() catch {};

    std.debug.print("device is: {s}\n", .{d_string});

    _ = try device.deinit(&d);
}
