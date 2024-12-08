#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <stdio.h>

int main() {
  int fd = open("./realt.txt", O_RDONLY);

  struct stat buf;
  fstat(fd, &buf);

  char *file = mmap(NULL, buf.st_size +1, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_PRIVATE , fd, 0); 
  file[buf.st_size] = '\0';

  int col1 = 0;
  int col2 = 0;
  char *line;
  line = strtok(file,"\n");
  while (line != NULL) {
    int n1;
    int n2;
    sscanf(line, "%d %d", &n1, &n2);
    col1 += n1;
    col2 += n2;
    line = strtok(NULL, "\n");
  }
  printf("%d", col2 - col1);

  return 0;
}
