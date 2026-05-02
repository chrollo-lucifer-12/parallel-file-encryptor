const std = @import("std");
const linked_list_mod = @import("linked-list.zig");

pub fn Queue(comptime T: type) type {
    const List = linked_list_mod.LinkedList(T);
    const NodeT = linked_list_mod.Node(T);

    return struct {
        list: List = .{},

        pub fn enqueue(self: *@This(), node: *NodeT) void {
            self.list.pushToBack(node);
        }

        pub fn dequeue(self: *@This()) ?*NodeT {
            return self.list.removeFromFront();
        }

        pub fn isEmpty(self: *@This()) bool {
            return self.list.head == null;
        }
    };
}
