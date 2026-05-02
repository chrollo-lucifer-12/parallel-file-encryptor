const std = @import("std");

pub fn UniquePtr(comptime T: type) type {
    return struct {
        ptr: ?*T,
        allocator: std.mem.Allocator,

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator, value: T) !Self {
            const p = try allocator.create(T);
            p.* = value;

            return Self{ .ptr = p, .allocator = allocator };
        }

        pub fn get(self: *Self) *T {
            return self.ptr.?;
        }

        pub fn deinit(self: *Self) void {
            if (self.ptr) |p| {
                self.allocator.destroy(p);
                self.ptr = null;
            }
        }

        pub fn move(self: *Self) Self {
            const new = Self{ .ptr = self.ptr, .allocator = self.allocator };

            self.ptr = null;
            return new;
        }
    };
}
