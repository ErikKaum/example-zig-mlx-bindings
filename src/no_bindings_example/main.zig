const std = @import("std");

const c = @cImport({
    @cInclude("mlx/c/mlx.h");
    @cInclude("mlx/c/string.h");
});

pub fn main() !void {
    const stream = c.mlx_default_cpu_stream_new();
    defer _ = c.mlx_stream_free(stream);

    const data = [_]f32{ 1, 2, 3, 4, 5, 6 };
    const shape = [_]c_int{ 2, 3 };

    // NOTE @prtCast isn't nice
    var arr = c.mlx_array_new_data(@ptrCast(&data), &shape, 2, c.MLX_FLOAT32);
    defer _ = c.mlx_array_free(arr);

    print_array("original array\n", arr);

    const two = c.mlx_array_new_int(2);
    defer _ = c.mlx_array_free(two);

    _ = c.mlx_divide(&arr, arr, two, stream);
    print_array("divided by 2\n", arr);

    _ = c.mlx_arange(&arr, 0, 3, 0.5, c.MLX_FLOAT32, stream);
    print_array("arange\n", arr);
}

fn print_array(msg: []const u8, arr: c.mlx_array) void {
    var mlx_string = c.mlx_string_new();
    _ = c.mlx_array_tostring(&mlx_string, arr);
    std.debug.print("{s} {s}\n", .{ msg, c.mlx_string_data(mlx_string) });
    _ = c.mlx_string_free(mlx_string);
}
