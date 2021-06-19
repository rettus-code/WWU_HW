#if !defined(_ef7809ab_cb6c_11e3_85da_f0def131db66)
#define _ef7809ab_cb6c_11e3_85da_f0def131db66

#include <stdio.h>

/* The natural number data type
 * 
 */
struct natural_st {
   unsigned byte_count;
   unsigned char* bytes;
};
typedef struct natural_st natural_t;

/* Free Natural 
 * Release the memory allocated for this natural.
 */
void release_natural(natural_t* nat);

/* Add Naturals
 * Add the left and right values together producing a new natural type.
 */
natural_t add_naturals(natural_t left, natural_t right);

/* Read Natural
 * This function reads a natural number from source, which is probably the
 * console, returning a newly created natural number type.  Characters a read
 * one at a time until a non-hex character is found.
 */
natural_t read_natural(FILE* source);

/* Print Natural
 * This function prints the natural number to the destination, which is probably
 * the console.  The number is printed in hex.
 */
void print_natural(FILE* destination, natural_t natural);


#endif
