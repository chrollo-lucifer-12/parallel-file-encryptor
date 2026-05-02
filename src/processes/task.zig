const std = @import("std");
const io_mod = @import("../file-handling/io.zig").IO;

pub const Action = enum { ENCRYPT, DECRYPT };

pub const Task = struct {
    file_path: []const u8,
    file: std.Io.File,
    action: Action,

    pub fn init(file: std.Io.File, file_path: []const u8, action: Action) Task {
        return Task{ .file = file, .file_path = file_path, .action = action };
    }

    pub fn deinit(self: *Task, io: std.Io) void {
        self.file.close(io);
    }

    pub fn fromString(task_data: []const u8, io: std.Io) !Task {
        var it = std.mem.splitScalar(u8, task_data, ',');

        const part1 = it.next() orelse return error.InvalidFormat;
        const part2 = it.next() orelse return error.InvalidFormat;

        const action = if (std.mem.eql(u8, part2, "ENCRYPT"))
            Action.encrypt
        else if (std.mem.eql(u8, part2, "DECRYPT"))
            Action.decrypt
        else
            return error.InvalidAction;

        const file = try io_mod.init(io, part1);

        return Task{
            .file_path = part1,
            .action = action,
            .file = file,
        };
    }
};
