/* This program reads a line from the console and verifies that it matches the
 * encrypted for of a string literal.  The cipher used is a simple substitution,
 * which is held as a constant character array.  The program succeeds if the
 * string matches, otherwise, it reports the error and returns failure.
 *
 * Unlike true encryption, spaces, punctuation, and capitalization are
 * preserved.  
 */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* Encrypt
 * This function runs the substitution cipher in-place.  That is, line is
 * modified.
 *
 */

// This is a slight modification of puzzle 1.  Run the input string through a
// non-trivial, substitution cipher and check to see if it matches a string of
// your choosing between 10 and 80 characters long.  You will have to classify
// the characters of the input string.  There are a few libc function that can
// help with this.  Consider reading the man-pages for isalph(3), isupper(3),
// and ispuct(3).  There are conversion functions between upper-case and
// lower-case: toupper(3) and tolower(3).  
//
// You must convert the input string.  You may not encrypt your chosen string.
// While that does solve the problem it defeats the purpose of the assignment. 
//
// Before turning in your solution, remove the comment block the begin with the
// double slash (e.g., //).  If you solution is somewhat difficult to
// understand, add a line to the block comment above with hints to the reader.
void encrypt(char* line) {
}

/* Matches
 * Returns true if line is the encrypted form of the string literal.  
 * 
 */
bool matches(char* line) {
  encrypt(line);
  return 0;
}


/* Main
 * Returns success if the input string matches (above).  Otherwise, it returns
 * failure.  
 *
 * There are really two failure modes: gitline falure, input mismatch.  In the
 * former case, perror is used to display the error condition set by getline.
 * In the latter case, the a brief error message is printed.  
 *
 * Note the if-statement that removes the trailing new-line.  The last character
 * from getline does not have to be a new-line, so the if-statement is
 * required.  
 */
// Do not modify this function!
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
