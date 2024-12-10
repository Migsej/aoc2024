const std = @import("std");

pub fn main() !void {
  var inputfile = try std.fs.cwd().openFile("./input", .{});
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

  std.debug.print("{}\n", .{disk});
  var block_end = disk.items.len;
  while (block_end > 0) {
    block_end -= 1;
    var block_start = block_end;
    while (disk.items[block_start] != free_digit and block_start != 0) {
      block_start -= 1;
    }
    const block_len = block_end - block_start;
    var i: usize = 0;
    while (i < block_start) {
      for (i..i+block_len) |j| {
        if (disk.items[j] != free_digit) {
          break;
        }
      } else {
        for (0..block_len) |k| {
          disk.items[i+k] = disk.items[block_start+k];
          disk.items[block_start+k] = free_digit;
        }
        break;
      }
      i += 1;
      std.debug.print("{}\n", .{disk});
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
