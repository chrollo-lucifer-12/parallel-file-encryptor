const std = @import("std");
const Task = @import("task.zig").Task;

pub const ProcessManagement = struct {
    queue: std.Io.Queue(*Task),

    pub fn init(self: *ProcessManagement) ProcessManagement {
        self.queue = std.Io.Queue(*Task);
        return ProcessManagement{};
    }

    pub fn submitToQueue(self: *ProcessManagement, io: std.Io, task: *Task) !void {
        try self.queue.putOne(io, task);
    }

    pub fn executeTasks(self: *ProcessManagement, io: std.Io) !void {
        while (try !self.queue.capacity() != 0) {
            const front_task = try self.queue.getOne(io);
            var buf = [1024]u8;
            std.debug.print("executing task : {s}\n", .{front_task.to_string(&buf)});
        }
    }
};
