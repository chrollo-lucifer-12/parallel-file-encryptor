const std = @import("std");
const Task = @import("task.zig").Task;

pub const ProcessManagement = struct {
    queue: std.ArrayList(*Task),

    pub fn init(allocator: std.mem.Allocator) ProcessManagement {
        return .{
            .queue = std.ArrayList(*Task).initCapacity(allo, num: usize)
        };
    }

    pub fn deinit(self: *ProcessManagement) void {
        self.queue.deinit();
    }

    pub fn submitToQueue(self: *ProcessManagement, task: *Task) !void {
        try self.queue.append(task);
    }

    pub fn executeTasks(self: *ProcessManagement) void {
        while (self.queue.items.len > 0) {
            const task = self.queue.orderedRemove(0);

            var buf: [1024]u8 = undefined;
            const s = task.to_string(&buf) catch "error";

            std.debug.print("executing task: {s}\n", .{s});
        }
    }
};
