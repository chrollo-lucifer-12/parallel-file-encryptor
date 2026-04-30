const std = @import("std");
const ReadEnv = @import("file-handling/read-env.zig").ReadEnv;

pub fn main(init: std.process.Init) !void {
    const gap = std.heap.page_allocator;
    const io = init.io;

    var env = try ReadEnv.getEnv(io, gap);

    const required = [_][]const u8{
        "SECRET_KEY",
    };

    for (required) |key| {
        if (!env.contains(key)) {
            std.debug.print("Missing required env: {s}\n", .{key});
            return error.MissingEnv;
        }
    }

    std.debug.print("All required envs present\n", .{});
}
