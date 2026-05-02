const std = @import("std");
const io_mod = @import("../file-handling/io.zig");
const task = @import("../processes/task.zig");

pub fn executeCryption(task_str: []u8, io: std.Io, key: []const u8) !void {
    const new_task = try task.fromString(task_str, io);
    const key_int = try std.fmt.parseInt(i32, key, 10);
    const key_byte: u8 = @intCast(@mod(key_int, 256));

    if (new_task.action == task.Action.ENCRYPT) {
        var task_file = new_task.file;
        defer task_file.deinit(io);

        var buffer: [1024]u8 = undefined;

        var file_obj = task_file.getFile();
        var reader = file_obj.reader(io, &buffer);

        const stat = try file_obj.stat(io);

        const allocator = std.heap.page_allocator;

        const data = try reader.interface.readAlloc(allocator, stat.size);
        defer allocator.free(data);

        for (data) |*b| {
            b.* +%= key_byte;
        }

        try file_obj.writePositionalAll(io, data, 0);
        try file_obj.setLength(io, data.len);
    } else if (new_task.action == task.Action.DECRYPT) {
        var task_file = new_task.file;
        defer task_file.deinit(io);

        var buffer: [1024]u8 = undefined;

        var file_obj = task_file.getFile();
        var reader = file_obj.reader(io, &buffer);

        const stat = try file_obj.stat(io);

        const allocator = std.heap.page_allocator;

        const data = try reader.interface.readAlloc(allocator, stat.size);
        defer allocator.free(data);

        for (data) |*b| {
            b.* -%= key_byte;
        }

        try file_obj.writePositionalAll(io, data, 0);
    }
}
