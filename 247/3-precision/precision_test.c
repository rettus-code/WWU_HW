#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "natural.h"


/* is all hex
 * Verify that all of the characters in the strings are valid hex digits. 
 *
 */
int is_all_hex(char* input)
{
   int i;
   int valid = 1;
   int len = strlen(input);

   assert (input != NULL);

   for(i = 0; i<len; ++i) {
      valid = valid && isxdigit(input[i]);
   }

   return valid;
}


/* This program is a test driver for arbitrary precision addition.  It expects
 * two integers expressed in hex as command-line arguments.  Naturals, however,
 * are read from streams.  Libc has a memory stream.  These look like file
 * streams, but they actually "read" from the strings.  This lets us read two
 * natural numbers, add them together, and display the results.  There is a
 * little bookkeeping at the end to free or release the memory used by the
 * natural numbers.  These would be destructors or finalizers in C++ or Java.
 */
int main(int argc, char* argv[])
{
   natural_t l,r,s;
   FILE* fmem;

   if (argc != 3 || !is_all_hex(argv[1]) || !is_all_hex(argv[2])) {
      fprintf(stderr, "Usage: %s {hexdigits} {hexdigits}\n", argv[0]);
      return EXIT_FAILURE;
   }

   fmem = fmemopen(argv[1], strlen(argv[1]), "r");
   l = read_natural(fmem);
   fclose(fmem);

   fmem = fmemopen(argv[2], strlen(argv[2]), "r");
   r = read_natural(fmem);
   fclose(fmem);
   
   s = add_naturals(l,r);

   print_natural(stdout, s);
   printf("\n");

   release_natural (&l);
   release_natural (&r);
   release_natural (&s);

   return EXIT_SUCCESS;
}
