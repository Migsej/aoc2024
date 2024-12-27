package main

import "core:fmt"
import "core:os"
import "core:bytes"
import "core:strings"
import "core:strconv"

Gate_type :: enum {
  XOR,
  AND,
  OR,
}

Gate :: struct {
  type: Gate_type,
  a: string,
  b: string,
}

Value :: union {
  bool,
  Gate,
}

eval :: proc(name: string, values: ^map[string]Value) -> bool {
  switch v in  values[name] {
    case bool:
      return v
    case Gate:
      a := eval(v.a, values)
      b := eval(v.b, values)
      res: bool
      switch v.type {
        case Gate_type.XOR:
          res = a != b
        case Gate_type.AND:
          res = a && b
        case Gate_type.OR:
          res = a || b
      }
      values[name] = res
      return res
  }
  return false
}

main :: proc() {
  data, ok := os.read_entire_file("./real_input")
  if !ok {
    fmt.println("AAAAAAAAAAAA")
    return
  }
  defer delete(data)
  splitindex := bytes.index(data, []u8{10, 10})
  inital_values_str := string(data[:splitindex])
  gates_str := string(data[splitindex+2:])
  values := make(map[string]Value)
  defer delete(values)

  for value in strings.split_lines_iterator(&inital_values_str) {
    colon := strings.index(value, ":")
    name := value[:colon]
    values[name] = true if value[colon+2:colon+3] == "1" else false
  }

  for gate in strings.split_lines_iterator(&gates_str) {
    parts := strings.split(gate, " ")
    defer delete(parts)
    gate: Gate
    gate.a = parts[0]
    gate.b = parts[2]
    switch parts[1] {
      case "XOR":
        gate.type = Gate_type.XOR
      case "AND":
        gate.type = Gate_type.AND
      case "OR":
        gate.type = Gate_type.OR
    }
    values[parts[4]] = gate
  }
  fmt.println(values)
  result := make([dynamic]bool)
  for key in values {
    if strings.has_prefix(key, "z") {
      v := eval(key, &values)
      index := strconv.atoi(key[1:])
      if index >= len(result) {
        resize(&result, index+1)
      }
      result[index] = v
    }
  }
  fmt.println(result)
  result_num := 0
  #reverse for bit in result {
    result_num <<= 1
    if bit {
      result_num |= 1
    }
  }
  fmt.println(result_num)
}


