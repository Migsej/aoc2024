package part_two

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import stb_image "vendor:stb/image"

robot :: struct {
  px: int,
  py: int,
  vx: int,
  vy: int,
}

main :: proc() {
	data, ok := os.read_entire_file("./real_input.txt")
	if !ok {
  	fmt.println("coluld not read file")
		return 
	}
	defer delete(data)
	data_str := string(data)
	robots := make([dynamic]robot, 0)
	currobot: robot = ---
	for line in strings.split_lines_iterator(&data_str) {
  	line_index := 0
  	for i in 0..<4 {
    	line_index += strings.index_any(line[line_index:], "-0123456789")
    	value := strconv.atoi(line[line_index:])
    	switch i {
      	case 0:
        	currobot.px = value
      	case 1:
        	currobot.py = value
      	case 2:
        	currobot.vx = value
      	case 3:
        	currobot.vy = value
    	}
    	for line_index != len(line) && strings.contains_rune("-0123456789", rune(line[line_index])) {
      	line_index += 1
    	}
  	}
  	append(&robots, currobot)
	}


  image: [103*101]u32
  for seconds in 1..<10000 {
    for i in 0..<len(robots) {
      robots[i].px = (robots[i].px + robots[i].vx) %% 101
      robots[i].py = (robots[i].py + robots[i].vy) %% 103
    }
    for y in 0..<103 {
      row: for x in 0..<101 {
        for robot in robots {
          if robot.px == x && robot.py == y {
            image[y*101+x] = 0xffffffff
            continue row
          }
        }
        image[y*101+x] = 0x000000ff
      }
    }
    stb_image.write_png(strings.unsafe_string_to_cstring(fmt.aprint("image", seconds, ".png", sep="")), 101, 103, 4, &image, 101*4)
  }
}

