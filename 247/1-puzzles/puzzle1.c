#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool matches(char* line) {
  return strcmp("I chose this string.", line) == 0;
}


int main() {
  bool   isSuccess = false;
  char*  line = NULL;
  size_t size = 0;
  size_t len  = getline(&line, &size, stdin);

  if(-1 == len) {
    perror("getline");
  }
  else {
    
    if(line[len-1] == '\n') {
      line[len-1] = '\0';
    }
       
    isSuccess = matches(line);

    if(!isSuccess) {
      printf("Didn't match\n");
    }
   
    free(line);
  }

  return isSuccess ? EXIT_SUCCESS : EXIT_FAILURE;
}
