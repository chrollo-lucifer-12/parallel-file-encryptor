const std = @import("std");
const task = @import("task.zig");
const queue = @import("../data-structures/queue.zig");
const linked_list = @import("../data-structures/linked-list.zig");
const cryption = @import("../encrypt-decrypt/cryption.zig");

pub const ProcessManagement = struct {
    task_queue: queue.Queue(*task.Task),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) ProcessManagement {
        return ProcessManagement{ .task_queue = queue.Queue(*task.Task){}, .allocator = allocator };
    }

    pub fn submitToQueue(self: *ProcessManagement, newTask: *task.Task) !void {
        const NodeT = linked_list.Node(*task.Task);

        const node = try self.allocator.create(NodeT);

        node.* = NodeT.init(newTask);

        self.task_queue.enqueue(node);
    }

    pub fn executeTasks(self: *ProcessManagement) !void {
        while (self.task_queue.isEmpty() == false) {
            if (self.task_queue.dequeue()) |node| {
                const task_to_execute = node.data;
                const task_str = try task_to_execute.toString(self.allocator);
                std.debug.print("executing task : {s}\r\n", .{task_str});
                cryption.executeCryption(task_str);
                self.allocator.destroy(node);
            }
        }
    }
};
