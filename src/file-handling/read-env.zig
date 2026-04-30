const io_mod = @import("io.zig");
const std = @import("std");

pub const ReadEnv = struct {
    pub fn getEnv(io: std.Io, allocator: std.mem.Allocator) !std.StringHashMap([]const u8) {
        var map = std.StringHashMap([]const u8).init(allocator);

        const env_path: []const u8 = ".env";

        var file = try io_mod.IO.init(io, env_path);
        defer file.deinit(io);

        var file_obj = file.getFile();
        var buffer: [1024]u8 = undefined;

        var reader = file_obj.reader(io, &buffer);

        while (true) {
            const line = reader.interface.takeDelimiterInclusive('\n') catch |err| {
                if (err == error.EndOfStream) break;
                return err;
            };

            const trimmed = std.mem.trimEnd(u8, line, "\r\n");
            if (trimmed.len == 0) continue;

            const eq_index = std.mem.indexOfScalar(u8, trimmed, '=') orelse continue;

            const key = std.mem.trim(u8, trimmed[0..eq_index], " ");
            const value = std.mem.trim(u8, trimmed[eq_index + 1 ..], " ");

            try map.put(key, value);
        }
        return map;
    }
};
