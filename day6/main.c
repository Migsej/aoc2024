#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>

typedef enum {
  GT_EMPTY,
  GT_OBSTACLE,
  GT_VISITID,
} ground_type;

int main() {
  int fd = open("./real_input.txt", O_RDONLY);
  struct stat st;
  fstat(fd, &st);
  char *file = mmap(0, st.st_size, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
  int line_length = strchr(file, '\n')-file;
  int lines = st.st_size/(line_length+1);
  int map[lines][line_length];

  int guy_x = -1;
  int guy_y = -1;
  int guy_vx = 0;
  int guy_vy = -1;

  for (int y = 0; y < lines; y++) {
    for (int x = 0; x < line_length; x++) {
      char cur_char = file[y*(line_length+1)+x];
      switch (cur_char) {
        case '.':
          map[y][x] = GT_EMPTY;
          break;
        case '#':
          map[y][x] = GT_OBSTACLE;
          break;
        case '^':
          guy_y = y;
          guy_x = x;
          break;
        default:
          printf("%d, %d: Unknown %c", x, y, cur_char);
          return 1;
      }
    }
  }

  map[guy_y][guy_x] = GT_VISITID;
  while (1) {
    int newguy_y = guy_y + guy_vy;
    int newguy_x = guy_x + guy_vx;
    if (map[newguy_y][newguy_x] == GT_OBSTACLE) {
      int temp = guy_vx;
      if (guy_y != 0) {
        guy_vx = -guy_vy;
        guy_vy = temp;
      } else {
        guy_vx = guy_vy;
        guy_vy = temp;

      }
    }
    guy_y += guy_vy;
    guy_x += guy_vx;

    if (!(guy_x >= 0 && guy_x < line_length && guy_y >= 0 && guy_y < lines)) {
      break;
    }
    map[guy_y][guy_x] = GT_VISITID;
  }

  int result = 0;
  for (int y = 0; y < lines; y++) {
    for (int x = 0; x < line_length; x++) {
      if (map[y][x] == GT_VISITID) result++;
    }
  }
  printf("%d\n", result);

  munmap(file, st.st_size);

  return 0;
}
