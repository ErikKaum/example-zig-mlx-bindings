const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "example-zig-mlx-bindings",
        .root_source_file = b.path("src/no_bindings_example/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // TODO can't pass optimize yet
    const mlx_c = b.dependency("mlx-c", .{ .target = target });
    exe.linkLibrary(mlx_c.artifact("mlx-c"));
    exe.installHeadersDirectory(mlx_c.path(""), "", .{});

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
