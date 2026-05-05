const std = @import("std");
const task = @import("task.zig");
const queue = @import("../data-structures/queue.zig");
const linked_list = @import("../data-structures/linked-list.zig");
const cryption = @import("../encrypt-decrypt/cryption.zig");

pub const ProcessManagement = struct {
    task_queue: queue.Queue(task.Task),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) ProcessManagement {
        return ProcessManagement{ .task_queue = queue.Queue(task.Task){}, .allocator = allocator };
    }

    pub fn submitToQueue(self: *ProcessManagement, newTask: task.Task) !void {
        const NodeT = linked_list.Node(task.Task);

        const node = try self.allocator.create(NodeT);

        node.* = NodeT.init(newTask);

        std.debug.print("new task came {s}\n", .{newTask.file_path});

        self.task_queue.enqueue(node);
    }

    pub fn executeTasks(self: *ProcessManagement, io: std.Io, secret_key: []const u8) !void {
        while (self.task_queue.isEmpty() == false) {
            if (self.task_queue.dequeue()) |node| {
                var task_to_execute = node.data;
                defer self.allocator.free(task_to_execute.file_path);

                const task_str = try task_to_execute.toString(self.allocator);
                defer self.allocator.free(task_str);

                std.debug.print("executing task : {s}\r\n", .{task_str});

                try cryption.executeCryption(task_str, io, secret_key);
                self.allocator.destroy(node);
            }
        }
    }
};
