const std = @import("std");
const ReadEnv = @import("file-handling/read-env.zig").ReadEnv;
const process_manager = @import("processes/process-management.zig").ProcessManagement;
const task_mod = @import("processes/task.zig");
const io_mod = @import("file-handling/io.zig").IO;

pub fn main(init: std.process.Init) !void {
    const allocator = std.heap.page_allocator;
    const io = init.io;

    const minimal = init.minimal;
    const args = try minimal.args.toSlice(init.arena.allocator());

    const file_path = args[1];

    var env = try ReadEnv.getEnv(io, allocator);

    if (!env.contains("SECRET_KEY")) {
        std.debug.print("Missing required env: SECRET_KEY\n", .{});
        return error.MissingEnv;
    }

    const secret_key = "190344093";

    var q = process_manager.init(allocator);

    const file = try io_mod.init(io, file_path);

    const task = task_mod.Task.init(
        file,
        file_path,
        task_mod.Action.DECRYPT,
    );

    try q.submitToQueue(task);

    try q.executeTasks(io, secret_key);
}
