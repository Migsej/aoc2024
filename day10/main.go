package main

import (
  "os"
  "fmt"
  "bytes"
)
	
type position struct {
    x int
    y int
}

func contains(haystack []position, needle position) bool {
  for _, x := range haystack {
    if needle == x {
      return true
    }
  }
  return false
}

func dfs(trail_map [][]int8, length int, lines int, v position) int {
  neighbours := []position{ position{y: 1, x: 0}, position{y: -1, x: 0}, position{x: 1, y: 0}, position{x: -1, y: 0}}
  result := 0
  s := make([]position, 0)
  discovered_poses := make([]position, 0)
  s = append(s, v)

  for len(s) > 0 {
    v = s[len(s)-1]
    s = s[:len(s)-1]
    if !contains(discovered_poses, v){
      if trail_map[v.x][v.y] == 9 {
        result += 1
      } 
      discovered_poses = append(discovered_poses, v)
      for _, neighbour_diff := range neighbours {
        neighbour := position{y: v.y+neighbour_diff.y, x: v.x+neighbour_diff.x}
        if neighbour.x < 0 || neighbour.y < 0 || neighbour.x >= length || neighbour.y >= lines {
          continue
        }
        dist := trail_map[neighbour.x][neighbour.y] - trail_map[v.x][v.y]
        if dist == 1 {
           s = append(s, neighbour)
        }
      }
    }
  }
  return result
}

func dfs_part2(trail_map [][]int8, length int, lines int, v position) int {
  neighbours := []position{ position{y: 1, x: 0}, position{y: -1, x: 0}, position{x: 1, y: 0}, position{x: -1, y: 0}}
  result := 0
  s := make([]position, 0)
  s = append(s, v)

  for len(s) > 0 {
    v = s[len(s)-1]
    s = s[:len(s)-1]
    if trail_map[v.x][v.y] == 9 {
      result += 1
    } 
    for _, neighbour_diff := range neighbours {
      neighbour := position{y: v.y+neighbour_diff.y, x: v.x+neighbour_diff.x}
      if neighbour.x < 0 || neighbour.y < 0 || neighbour.x >= length || neighbour.y >= lines {
        continue
      }
      dist := trail_map[neighbour.x][neighbour.y] - trail_map[v.x][v.y]
      if dist == 1 {
         s = append(s, neighbour)
      }
    }
  }
  return result
}

func part1(trail_map [][]int8, length int, lines int) int {
  result := 0
  for i := 0; i < lines; i++ {
    for j := 0; j < lines; j++ {
      if trail_map[i][j] == 0 {
        result += dfs(trail_map, length, lines, position{x: i, y: j});
      }
    }
  }
  return result
}

func part2(trail_map [][]int8, length int, lines int) int {
  result := 0
  for i := 0; i < lines; i++ {
    for j := 0; j < lines; j++ {
      if trail_map[i][j] == 0 {
        result += dfs_part2(trail_map, length, lines, position{x: i, y: j});
      }
    }
  }
  return result
}

func main() {
  data, err := os.ReadFile("./real_input")
  if err != nil {
    panic(err)
  }
  length := bytes.IndexByte(data, '\n')
  lines := len(data)/(length+1)

  trail_map := make([][]int8, lines)
  for i:=0; i<lines; i++ {
    trail_map[i] = make([]int8, length)
  }

  for i := 0; i < lines; i++ {
    for j := 0; j < lines; j++ {
      trail_map[i][j] = int8(data[i*(length+1)+j] - '0')
   }
  }
  result := part2(trail_map, length, lines);

  fmt.Println(result)

  result = part1(trail_map, length, lines);

  fmt.Println(result)


}
