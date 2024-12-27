package main

import "core:fmt"
import "core:os"
import "core:bytes"

main :: proc() {
  data, ok := os.read_entire_file("./input")
  defer delete(data)
  splitindex := bytes.index(data, []u8{10, 10})
  moves := string(data[splitindex+2:])
  room_str := string(data[:splitindex])
  fmt.println(moves)
  fmt.println(room_str)
}
