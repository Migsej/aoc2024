package main

import "core:fmt"
import "core:strconv"
import "core:os"
import "core:strings"
import "core:math"

game :: struct {
  a_x: int,
  a_y: int,
  b_x: int,
  b_y: int,
  prize_x: int,
  prize_y: int,
}


playgame :: proc(game: game) -> int {
  i :=  (game.prize_y*game.a_x - game.prize_x*game.a_y)/(game.b_y*game.a_x - game.b_x*game.a_y)
  j := -(game.prize_y*game.b_x - game.prize_x*game.b_y)/(game.b_y*game.a_x - game.b_x*game.a_y)
  if j*game.a_x + i*game.b_x != game.prize_x ||  j*game.a_y + i*game.b_y != game.prize_y {
    return 0
  }
  if i > 100 || j > 100 {
    return 0 }
  return j*3 + i
}

playgame_part2 :: proc(game: game) -> int {
  game := game
  game.prize_x += 10000000000000
  game.prize_y += 10000000000000
  i :=  (game.prize_y*game.a_x - game.prize_x*game.a_y)/(game.b_y*game.a_x - game.b_x*game.a_y)
  j := -(game.prize_y*game.b_x - game.prize_x*game.b_y)/(game.b_y*game.a_x - game.b_x*game.a_y)
  if j*game.a_x + i*game.b_x != game.prize_x ||  j*game.a_y + i*game.b_y != game.prize_y {
    return 0
  }
  return j*3 + i
}

main :: proc() {
	data, ok := os.read_entire_file("./real_input.txt")
	if !ok {
  	fmt.println("coluld not read file")
		return 
	}
	defer delete(data)
	data_str := transmute(string)data

  games := make([dynamic]game, 0)
  i := 0
  structindex := 0
	newgame: game = ---
	for {
  	nextnum := strings.index_any(data_str[i:], "0123456789")
  	if nextnum == -1 {
    	break
  	}
  	i += nextnum
  	value := strconv.atoi(data_str[i:])
  	switch structindex {
    	case 0:
      	newgame.a_x = value
    	case 1:
      	newgame.a_y = value
    	case 2:
      	newgame.b_x = value
    	case 3:
      	newgame.b_y = value
    	case 4:
      	newgame.prize_x = value
    	case 5:
      	newgame.prize_y = value
      	append(&games, newgame)
  	}
  	structindex = (structindex +1) % 6
  	for strings.contains_rune("0123456789", rune(data_str[i])) {
    	i += 1
  	}
	}

  result := 0
	for game in  games {
  	result += playgame(game);
	}
	fmt.println(result)
}
