const std = @import("std");

pub fn Node(comptime T: type) type {
    return struct {
        data: T,
        next: ?*@This(),

        pub fn init(value: T) @This() {
            return .{ .data = value, .next = null };
        }
    };
}

pub fn LinkedList(comptime T: type) type {
    const NodeT = Node(T);

    return struct {
        head: ?*NodeT = null,

        pub fn pushToFront(self: *@This(), node: *NodeT) void {
            node.next = self.head;
            self.head = node;
        }

        pub fn removeFromFront(self: *@This()) ?T {
            if (self.head == null) {
                return null;
            }
            const prevHead = self.head.?;
            self.head = prevHead.next;

            return prevHead.data;
        }
    };
}
