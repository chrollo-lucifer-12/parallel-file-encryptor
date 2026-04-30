const std = @import("std");

pub const IO = struct {
    file: std.Io.File,

    pub fn init(io: std.Io, file_path: []const u8) !IO {
        const cwd = std.Io.Dir.cwd();
        const file = try cwd.openFile(io, file_path, .{});

        return IO{ .file = file };
    }

    pub fn deinit(self: *IO, io: std.Io) void {
        self.file.close(io);
    }

    pub fn getFile(self: *IO) std.Io.File {
        return self.file;
    }
};
