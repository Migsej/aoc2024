const std = @import("std");

pub fn main() !void {
  var inputfile = try std.fs.cwd().openFile("./real_input", .{});
  defer inputfile.close();

  var buf_reader = std.io.bufferedReader(inputfile.reader());
  var in_stream = buf_reader.reader();

  //var buf: [8192]u8 = undefined;
  //const line = (try in_stream.readUntilDelimiterOrEof(&buf, '\n')).?;

  const allocator = std.heap.page_allocator;
  const line = (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize) )).?;

  var disk = std.ArrayList(usize).init(allocator);
  defer disk.deinit();

  const free_digit = line.len;
  for (line, 0..) |char_digit, i| {
    const digit = char_digit - '0';
    for (0..digit) |_| {
      if (i % 2 == 0) {
        try disk.append(i/2);
      } else {
        try disk.append(free_digit);
      }
    }
  }

  var i = disk.items.len;
  while (i > 0) {
    i -= 1;
    for (disk.items[0..i], 0..i) |file, file_index| {
      if (file == free_digit) {
        disk.items[file_index] = disk.items[i];
        disk.items[i] = free_digit;
        break;
      }
    }
  }

  var result: usize = 0;
  for (disk.items, 0..) |file,file_index| {
    if (file == free_digit) {
      break;
    }
    result += file*file_index;
  }

  std.debug.print("{}\n", .{result});
}
