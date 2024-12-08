#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>


int vx[] = { 0, 1, 0,-1};
int vy[] = {-1, 0, 1, 0};

bool traverse(int32_t lines, int32_t line_length, uint8_t file[lines][line_length+1], int32_t guy_x, int32_t guy_y) {
  uint8_t positions[lines][line_length];
  memset(positions, 0, sizeof(positions));

  int v = 0;
  while (1) {
    positions[guy_y][guy_x] |= (1 << v);
    int32_t newguy_y = guy_y + vy[v];
    int32_t newguy_x = guy_x + vx[v];
    if (!(newguy_x >= 0 && newguy_x < line_length && newguy_y >= 0 && newguy_y < lines)) {
      return false;
    }
    while (file[newguy_y][newguy_x] == '#') {
      v = (v +1) % 4;
      newguy_y = guy_y + vy[v];
      newguy_x = guy_x + vx[v];
    } 
    guy_y = newguy_y;
    guy_x = newguy_x;

    if (positions[guy_y][guy_x] & (1 << v)) {
      return true;
    }

  }
}

int main() {
  int fd = open("./real_input.txt", O_RDONLY);
  struct stat st;
  fstat(fd, &st);
  void *file = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);

  int32_t line_length = memchr(file, '\n', st.st_size)-file;
  int32_t lines = st.st_size/(line_length+1);
  uint8_t map[lines][line_length+1];
  memcpy(map, file, sizeof(map));

  int32_t startindex = memchr(map, '^', sizeof(map))-(void *)map;
  int32_t guy_y = startindex / (line_length+1);
  int32_t guy_x = startindex % (line_length+1);

  int32_t result = 0;
  for (int32_t y = 0; y < lines; y++) {
    for (int32_t x = 0; x < line_length; x++) {
      if (guy_y == y && guy_x == x) continue;
      if (map[y][x] == '#') continue;
      map[y][x] = '#';
      if (traverse(lines, line_length, map, guy_x, guy_y)) {
        result++;
      }
      map[y][x] = '.';
    }
  }

  printf("%d\n", result);

  munmap(file, st.st_size);

  return 0;
}
