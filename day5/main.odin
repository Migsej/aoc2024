package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:c/libc"

Entry :: struct {
  from: int,
  to: int,
}

part1 :: proc() {
	data, ok := os.read_entire_file("./input.txt", context.allocator)
	if !ok {
		// could not read file
		return 
	}
	defer delete(data, context.allocator)

	m := make([dynamic]Entry)
	defer delete(m)

	it := string(data)
	for line in  strings.split_lines_iterator(&it) {
  	if line == "" {
    	break
  	}
  	cur_entry : Entry
  	c_line, err := strings.clone_to_cstring(line)
  	if err != nil {
    	return 
  	}
    libc.sscanf(c_line, "%d|%d", &cur_entry.from,  &cur_entry.to)
    delete(c_line)

    append(&m, cur_entry)
	}
	result := 0
	for line in strings.split_lines_iterator(&it) {
  	xs := make([dynamic]int)
  	defer delete(xs)
  	for n in strings.split(line, ",") {
    	append(&xs, strconv.atoi(n))
  	}
  	valid_line := true
  	valid_line_check: for i in 0..<len(xs) {
    	for before in 0..<i {
      	for entry in m {
        	if xs[i] == entry.from && xs[before] == entry.to {
          	valid_line = false
          	break valid_line_check 
        	}
      	}
    	}
    	for before in i+1..<len(xs) {
      	for entry in m {
        	if xs[i] == entry.to && xs[before] == entry.from {
          	valid_line = false
          	break valid_line_check 
        	}
      	}
    	}

  	}
  	if valid_line {
    	result += xs[len(xs)/2]
  	}

	}
	fmt.println(result)

}

part2 :: proc() {
	data, ok := os.read_entire_file("./input.txt", context.allocator)
	if !ok {
		// could not read file
		return 
	}
	defer delete(data, context.allocator)

	m := make([dynamic]Entry)
	defer delete(m)

	it := string(data)
	for line in  strings.split_lines_iterator(&it) {
  	if line == "" {
    	break
  	}
  	cur_entry : Entry
  	c_line, err := strings.clone_to_cstring(line)
  	if err != nil {
    	return 
  	}
    libc.sscanf(c_line, "%d|%d", &cur_entry.from,  &cur_entry.to)
    delete(c_line)

    append(&m, cur_entry)
	}
	result := 0
	for line in strings.split_lines_iterator(&it) {
  	xs := make([dynamic]int)
  	defer delete(xs)
  	for n in strings.split(line, ",") {
    	append(&xs, strconv.atoi(n))
  	}
  	valid_line := true
  	valid_line_check: for i in 0..<len(xs) {
    	for before in 0..<i {
      	for entry in m {
        	if xs[i] == entry.from && xs[before] == entry.to {
          	valid_line = false
          	xs[i], xs[before] = xs[before], xs[i]
          	// break valid_line_check 
        	}
      	}
    	}
    	for before in i+1..<len(xs) {
      	for entry in m {
        	if xs[i] == entry.to && xs[before] == entry.from {
          	valid_line = false
          	xs[i], xs[before] = xs[before], xs[i]
          	// break valid_line_check 
        	}
      	}
    	}

  	}
  	if !valid_line {
    	fmt.println(xs)
    	result += xs[len(xs)/2]
  	}

	}
	fmt.println(result)

}


main :: proc() {
  part2()
}
