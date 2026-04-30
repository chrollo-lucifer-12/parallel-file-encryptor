const std = @import("std");
const io_mod = @import("../file-handling/io.zig").IO;

pub const Action = enum {
    ENCRYPT,
    DECRYPT,
};

pub const Task = struct {
    file_path: []const u8,
    action: Action,

    pub fn init(file_path: []const u8, action: Action) Task {
        return Task{
            .file_path = file_path,
            .action = action,
        };
    }

    pub fn to_string(self: *Task, buf: []u8) []u8 {
        const action_str = switch (self.action) {
            .ENCRYPT => "ENCRYPT",
            .DECRYPT => "DECRYPT",
        };

        return try std.fmt.bufPrint(
            buf,
            "{s},{s}",
            .{ self.file_path, action_str },
        );
    }

    pub fn from_string(input: []const u8) !Task {
        const comma_index = std.mem.indexOfScalar(u8, input, ',') orelse {
            return error.InvalidFormat;
        };

        const file_path = input[0..comma_index];
        const action_str = input[comma_index + 1 ..];

        const action = if (std.mem.eql(u8, action_str, "ENCRYPT"))
            Action.ENCRYPT
        else if (std.mem.eql(u8, action_str, "DECRYPT"))
            Action.DECRYPT
        else
            return error.InvalidAction;

        return Task.init(file_path, action);
    }
};
