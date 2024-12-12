package main

import "core:fmt"
import "core:os"
import "core:bytes"

adjx := []int{-1, 0, 1, 0}
adjy := []int{0, -1, 0, 1}
adj := soa_zip(x=adjx, y=adjy)


contains :: proc(haystack: []int, needle: int) -> bool {
  for x in haystack {
    if x == needle {
      return true
    }
  }
  return false
}


main :: proc() {
	data, ok := os.read_entire_file("./real_input.txt")
	if !ok {
  	fmt.println("coluld not read file")
		return 
	}
	defer delete(data)

  line_length := bytes.index_byte(data, '\n')
  lines := len(data)/(line_length+1)

  seen := make([dynamic]int, 0)
  defer delete(seen)
  s := make([dynamic]int, 0)
  defer delete(s)

  price := 0

  for y in 0..<lines {
    for x in 0..<line_length {

      index := y*(line_length+1) + x
      type := data[index]
      area := 0
      perimeter := 0
      if contains(seen[:], index) {
        continue
      }
      clear(&s)
      append(&s, index)

      for len(s) > 0 {
        v := pop(&s)
        if contains(seen[:], v) {
          continue
        }
        area += 1
        append(&seen, v)
        vx := (v % (line_length+1))
        vy := (v / (line_length+1))
        for diff in adj {
          neighbourx := vx + diff.x
          neighboury := vy + diff.y
          neighbour_index := neighboury*(line_length+1) + neighbourx
          outside := neighbourx < 0 || neighboury < 0 || neighbourx >= line_length || neighboury >= lines
          if outside || data[neighbour_index] != type {
            perimeter += 1
            continue
          }
          append(&s, neighbour_index)
        }
      }
      price += area * perimeter
    }
  }
  fmt.println(price)
}
