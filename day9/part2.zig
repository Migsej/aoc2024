const std = @import("std");

const FreeSpace = struct {
    start: usize,
    end: usize,
};

const OccupiedSpace = struct {
    start: usize,
    len: usize,
    id: usize,
};

// 8444425634594
pub fn main() !void {
  var inputfile = try std.fs.cwd().openFile("./real_input", .{});
  defer inputfile.close();

  var buf_reader = std.io.bufferedReader(inputfile.reader());
  var in_stream = buf_reader.reader();

  const allocator = std.heap.page_allocator;
  const line = (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize) )).?;

  var free = std.ArrayList(FreeSpace).init(allocator);
  defer free.deinit();
  var occupied = std.ArrayList(OccupiedSpace).init(allocator);
  defer occupied.deinit();

  var disksize: usize = 0;

  for (line, 0..) |char_digit, i| {
    const digit = char_digit - '0';
    if (i % 2 == 0) {
      try occupied.append(OccupiedSpace {
        .start = disksize,
        .len = digit,
        .id = i/2,
      });
    } else {
      if (digit != 0) {
        try free.append(FreeSpace {
          .start = disksize,
          .end = digit+disksize,
        });
      }
    }
    disksize += digit;
  }

  var i = occupied.items.len;
  while (i > 0) {
    i -= 1;
    for (free.items, 0..) |_, space_index| {
      if (free.items[space_index].end - free.items[space_index].start >= occupied.items[i].len and free.items[space_index].start < occupied.items[i].start ) {
        try free.append(FreeSpace {
          .start = occupied.items[i].start,
          .end  = occupied.items[i].start + occupied.items[i].len,
        });
        occupied.items[i].start = free.items[space_index].start;
        free.items[space_index].start += occupied.items[i].len;
        if (free.items[space_index].start == free.items[space_index].end) {
          _ = free.orderedRemove(space_index);
        }
        var k: usize = 0;
        while (k < free.items.len)  {
          var j: usize = 0;
          while (j < free.items.len) {
            if (k == j) {
              j += 1;
              continue;
            }
            if (j == free.items.len or k == free.items.len) {
              j += 1;
              break;
            }
            while ((free.items[k].start <= free.items[j].start and free.items[k].end >= free.items[j].end) or free.items[k].end == free.items[j].start) {
              free.items[k].end = free.items[j].end;
              _ = free.orderedRemove(j);
              if (j == free.items.len or k == free.items.len) {
                break;
              }
            }
            j += 1;
          }
          k += 1;
        }
       break;
      }
    }
  }


  var result: usize = 0;
  for (occupied.items) |block| {
    for (block.start..block.start+block.len) |index| {
      result += index*block.id;
    }
  }
  std.debug.print("{}\n", .{result});
}
