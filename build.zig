const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    // Create the executable target for your application.
    const exe = b.addExecutable("bouncing-squares-zig", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    // Assuming `cosmic/platform/backend.zig` and `cosmic/graphics/lib.zig` are correct paths.
    // Add `graphics` package explicitly.
    exe.addPackagePath("graphics", "cosmic/graphics/lib.zig");

    // Here we assume `backend` and `graphics` are namespaces/modules with functions
    // `getGraphicsBackend` and `addPackage` respectively, used for setting up your graphics backend.
    const backend = @import("cosmic/platform/backend.zig");
    const graphics = @import("cosmic/graphics/lib.zig");

    const graphics_backend = backend.getGraphicsBackend(exe);
    // Adjust this line if `graphics.addPackage` is not compatible with the package path added above.
    graphics.addPackage(exe, .{ .graphics_backend = graphics_backend });
    // Proceed with any build and link steps required by the graphics library.
    graphics.buildAndLink(exe, .{ .graphics_backend = graphics_backend });

    // Specify the output directory.
    exe.setOutputDir("zig-out");

    // Set up the run step.
    const run = exe.run();
    b.default_step.dependOn(&run.step);
}

// const target = b.standardTargetOptions(.{});
// const optimize = b.standardOptimizeOption(.{});

// const lib = b.addStaticLibrary(.{
//     .name = "bouncing-squares-zig",
//     .root_source_file = .{ .path = "src/root.zig" },
//     .target = target,
//     .optimize = optimize,
// });

// b.installArtifact(lib);

// const exe = b.addExecutable(.{
//     .name = "bouncing-squares-zig",
//     .root_source_file = .{ .path = "src/main.zig" },
//     .target = target,
//     .optimize = optimize,
// });

// b.installArtifact(exe);

// const graphics_backend = backend.getGraphicsBackend(exe);
// graphics.addPackage(exe, .{ .graphics_backend = graphics_backend });
// graphics.buildAndLink(exe, .{ .graphics_backend = graphics_backend });

// const run_cmd = b.addRunArtifact(exe);
// run_cmd.step.dependOn(b.getInstallStep());

// if (b.args) |args| {
//     run_cmd.addArgs(args);
// }

// const run_step = b.step("run", "Run the app");
// run_step.dependOn(&run_cmd.step);
