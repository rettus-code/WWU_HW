#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool matches(char *line) {
 
 char *token;
 int x = 1;
 int hold;
 token = strtok(line," ");
 int y = 0;
     while (token != NULL && (sscanf(token,"%d", &hold) == 1) && hold == x) {
	x = x+2;

	token = strtok(NULL," ");
	 if (token != NULL && (sscanf(token,"%d", &hold) == 1) && hold == x) {
	   y=0;
        } else { y =1;}
      }
       
     return y;
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

