#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool matches(char *line) {
  int hold;
 char *token;
 token = strtok(line," ");
 int x = 1;

    if (token != NULL && (sscanf(token,"%d", &hold) == 1) && hold == x) {
      return matchup(1, line); 
    } else { return 0;}
   
}
int matchup(int count, char* line) {
  printf(" %d\n", count);
  printf(" %s\n", line);
  char * token;
  int hold;
  int y;
  token = strtok(line, " ");
  
  if (token != NULL && (sscanf(token,"%d", &hold) == 1) && hold == count) {
    count = count + 2;
    token = strtok(NULL, " ");
    y=1;
    matchup(count, line+= 2);
  }
  if (token != NULL && (sscanf(token,"%d", &hold) == 1) && hold != count) { 
    y=0;
  
  return y;
}

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
