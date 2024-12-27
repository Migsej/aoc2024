package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"


combo :: proc(v: int, a: int, b: int, c: int) -> int {
  switch v {
    case 0, 1, 2, 3: return  v
    case 4:          return  a
    case 5:          return  b
    case 6:          return  c
    case:            return -1
  }
}

pow :: proc(a: int, b: int) -> int {
  b := b
  s := 1
  t := a
  for b != 0 { 
    if b&1 != 0 {
      s = s*t
    }
    t = t*t
    b >>= 1
  }
  return s
}

run_program :: proc(program: []int, a: int, b: int, c: int) -> [dynamic]int {
  res := make([dynamic]int)
  a := a
  b := b
  c := c
  ip := 0
  for ip < len(program) {
    operand := program[ip+1]
    switch program[ip] {
      case 0:
        a = a/pow(2, combo(operand, a, b, c))
      case 1:
        b = b ~ operand
      case 2:
        b = combo(operand, a, b, c) % 8
      case 3:
        if a != 0 {
          ip = operand-2
        }
      case 4:
        b = b ~ c
      case 5:
        append(&res, combo(operand, a, b, c)%8)
      case 6:
        b = a/pow(2, combo(operand, a, b, c))
      case 7:
        c = a/pow(2, combo(operand, a, b, c))
    }
    ip += 2
  }
  return res
}

parse_line :: proc(line: string) -> (int, bool)  {
  num_start := strings.index_any(line, "0123456789")
  if num_start == -1 {
    return 0, false
  }
  return strconv.parse_int(line[num_start:])
}

comp :: proc(a: []int, b: []int) -> bool {
  if len(a) != len(b) {
    return false
  }
  for i in 0..<len(a) {
    if a[i] != b[i] {
      return false
    }
  }
  return true
}

main :: proc() {
  data, ok := os.read_entire_file_from_filename("./real_input")
  if !ok {
  	fmt.println("could not read file")
  	return
  }
  defer delete(data)
  lines := strings.split_lines(string(data))
  register_a: int
  register_a, ok = parse_line(lines[0])
  if !ok {
    fmt.println("could not parse register")
    return
  }
  register_b: int
  register_b, ok = parse_line(lines[1])
  if !ok {
    fmt.println("could not parse register")
    return
  }
  register_c: int
  register_c, ok = parse_line(lines[2])
  if !ok {
    fmt.println("could not parse register")
    return
  }

  program := make([dynamic]int)
  defer delete(program)

  program_start := strings.index_any(lines[4], "0123456789")

  for num in strings.split(lines[4][program_start:], ",") {
    append(&program, strconv.atoi(num))

  }


  possibles := make([dynamic]int)
  defer delete(possibles)
  append(&possibles, 0)

  for len(possibles) > 0 {
    a := possibles[0]
    ordered_remove(&possibles, 0)
    for i in 0..<8 {
      program_result := run_program(program[:], a | i, register_b, register_c)
      if comp(program_result[:], program[len(program)-len(program_result):]) {
        if len(program_result) == len(program) {
          program_result := run_program(program[:], a | i, register_b, register_c)
          defer delete(program_result)
          fmt.println(program_result)
          fmt.println(a|i)
          return
        }
        append(&possibles, (a|i)<<3)
      }
    }
  }
}


