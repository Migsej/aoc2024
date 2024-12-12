package main

// corner criteria
// missing to adjecant thins
// has two adjecant with corner missing

// 012
// 7e3 
// 654
 
// 0 1 2 3 4 5 6 7
// 701
// 123
// 345
// 567
 
// eex
// eex -> eexxxxxxe -> eee, 
// xxx

import "core:fmt"
import "core:os"
import "core:bytes"

adj4x := []int{-1, 0, 1, 0}
adj4y := []int{0, -1, 0, 1}
adj4 := soa_zip(x=adj4x, y=adj4y)

adj8x := []int{-1,  0,  1, 1,  1, 0, -1, -1}
adj8y := []int{-1, -1, -1, 0,  1, 1,  1,  0}
adj8 := soa_zip(x=adj8x, y=adj8y)


cornerindex1 := []int{7, 1, 3, 5}
cornerindex2 := []int{0, 2, 4, 6}
cornerindex3 := []int{1, 3, 5, 7}

cornerindex := soa_zip(fst=cornerindex1,snd=cornerindex2,thd=cornerindex3)


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
      corners := 0
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
        for diff in adj4 {
          neighbourx := vx + diff.x
          neighboury := vy + diff.y
          neighbour_index := neighboury*(line_length+1) + neighbourx
          outside := neighbourx < 0 || neighboury < 0 || neighbourx >= line_length || neighboury >= lines
          if outside || data[neighbour_index] != type {
            continue
          }
          append(&s, neighbour_index)
        }
        neighbours: [8]bool
        for diff, i in adj8 {
          neighbourx := vx + diff.x
          neighboury := vy + diff.y
          neighbour_index := neighboury*(line_length+1) + neighbourx
          outside := neighbourx < 0 || neighboury < 0 || neighbourx >= line_length || neighboury >= lines
          if outside || data[neighbour_index] != type {
            neighbours[i] = false
          } else {
            neighbours[i] = true
          }
        }
        for corner in cornerindex {
          fst := neighbours[corner.fst]
          snd := neighbours[corner.snd]
          thd := neighbours[corner.thd]
          if fst && !snd && thd {
            corners += 1
          } else if !fst && !thd {
            corners += 1
          }
        }
      }
      price += area * corners
    }
  }
  fmt.println(price)
}
