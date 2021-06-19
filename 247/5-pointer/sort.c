#include "sort.h"
#include <string.h>


/* Swap two pointers.
 * The prototype of this function may look strange.  Left and right are pointers
 * to pointers to data of an unknown type.  What use a pointer to a pointer?  C
 * doesn't have pass-by-reference semantics, it only has pass-by-value.  This
 * means that any change swap makes to its parameters wouldn't effect the
 * arguments passed in by sort_array.  However, sort_array can pass pointers to
 * its data.  Now swap can change the data pointed at by its arguments.  What is
 * the type of that data?  They are pointers to an unknown type.
 */
static 
void swap(void** left, void** right) {
  void* temp = *left;
  *left = *right;
  *right = temp;
}

/* Sort Array 
 * This function sorts the data stored in the array.  Remember that C's arrays
 * are just pointers to data.  That is, they do not contain length information,
 * so we have to pass that ourselves.  The actual sorting routine is
 * Bubble-Sort.
 */
void sort_array(void* Array[], unsigned size, int (*ordered)(void*, void*))
{
  int i;
  int have_swapped = 1;

  while (have_swapped) {
    have_swapped = 0;
    for (i = 0; i < size - 1; ++i ){
      if ( ordered(Array[i], Array[i+1]) ) {
	swap(&Array[i], &Array[i+1]);  
	have_swapped = 1;
      }
    }
  }
}
