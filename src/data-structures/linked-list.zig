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
        tail: ?*NodeT = null,

        pub fn pushToFront(self: *@This(), node: *NodeT) void {
            node.next = self.head;
            self.head = node;
            if (self.tail == null) {
                self.tail = node;
            }
        }

        pub fn pushToBack(self: *@This(), node: *NodeT) void {
            node.next = null;

            if (self.tail) |tail| {
                tail.next = node;
            } else {
                self.head = node;
            }

            self.tail = node;
        }

        pub fn removeFromFront(self: *@This()) ?*NodeT {
            const node = self.head orelse return null;

            self.head = node.next;

            if (self.head == null) {
                self.tail = null;
            }

            return node;
        }
    };
}
