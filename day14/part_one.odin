package part_one

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

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


  for i in 0..<len(robots) {
    robots[i].px = (robots[i].px + robots[i].vx*100) %% 101
    robots[i].py = (robots[i].py + robots[i].vy*100) %% 103
  }

  q1 := 0
  q2 := 0
  q3 := 0
  q4 := 0
  for robot in robots {
    if robot.px < 50 && robot.py < 51 {
      q1 += 1
    } else if robot.px > 50 && robot.py < 51 {
      q2 += 1
    } else if robot.px > 50 && robot.py > 51 {
      q3 += 1
    } else if robot.px < 50 && robot.py > 51 {
      q4 += 1
    }
  }
  fmt.println(q1*q2*q3*q4)
}

