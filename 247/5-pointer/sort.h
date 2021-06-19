#ifndef _SORT_H_
#define _SORT_H_

/* Sort Array
 * Array  The array of pointers to unknown types.  
 * size   The number of elements in array
 *
 * This function sorts the array into the correct order, but I'm not sure what
 * correct is in this context.
 */
void sort_array(void* Array[], unsigned size, int (*ordered)(void*,void*));

#endif /*_SORT_H_*/
