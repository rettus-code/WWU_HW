#include "natural.h"
#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Release Natural 
 * Release the memory allocated for this natural.
 */
void release_natural(natural_t* nat)
{
   assert(nat != NULL);
   if (nat->bytes != NULL)
      free(nat->bytes);
   nat->bytes = NULL;
   nat->byte_count = 0;
}

/* Return the maximum of the two arguments.  
 */
static unsigned max(unsigned left, unsigned right)
{
   return left > right ? left : right;
}


/* Add Naturals Auxiliary function
 * This function is implemented in the assembly file natural_aux.s.  This
 * function performs the one byte add.  The carry arguments is both input and
 * output.  If it is one on input, one is added to dst.  If the addition results
 * in a carry, carry is one on output.
 */
void add_naturals_aux(unsigned char* dst,
                      unsigned char* src,
                      int* carry);

/* Add Naturals
 * Add the left and right values together producing a new natural type.
 *
 * (1) First, I create the result natural.  I allocate enough memory to hold the
 * larger of the two operands plus one.  The additional byte is necessary when
 * the addition carries over into a new position (e.g., 9+1 in base 10 or F+1 in
 * base 16).
 *
 * (2) The next step is to assign one of the two operands into the result.  This
 * is two steps, zeroing out the result and a memory-to-memory move.
 *
 * (3) The add is two steps.  I begin by adding the digits from the right
 * operand into the results.  The carry variable holds any carry out from one
 * "column" into the next.  I then cascade any carries across the rest of the
 * "columns."  For example, FFFF+1 will carry all the way across.  
 *
 * (4) It is possible that I didn't need the extra byte.  I could allocate just
 * enough data for the value and copy, but this seems like a lot of work for one
 * byte.  I simple reduce the byte_count by one and hold onto the unneeded
 * memory.
 */
natural_t add_naturals(natural_t left, natural_t right)
{
   natural_t result;
   int i;
   int carry = 0;
   unsigned char zero = 0;

   /* 1 */
   result.byte_count = 1 + max (left.byte_count, right.byte_count);
   result.bytes = (unsigned char*) malloc (1 + result.byte_count);

   /* 2 */
   bzero(result.bytes, result.byte_count);
   memcpy(result.bytes, left.bytes, left.byte_count);

   /* 3 loop had ++i in wrong spot causing a stack overflow ie segment fault*/
   for(i = 0; i < right.byte_count; ++i) {
      add_naturals_aux(&result.bytes[i], 
                       &right.bytes[i],
                       &carry);
   }

   while(carry && i < result.byte_count) {
      add_naturals_aux(&result.bytes[i], 
                       &zero,
                       &carry);
      ++i;
   }

   /* (4) */
   if (result.bytes[result.byte_count-1] == 0) {
      result.byte_count -= 1;
   }

   return result;
}


/* Convert a single hex digit to its value.
 */
static
unsigned char hex_to_value (char c)
{
   assert(isxdigit((int)c));
   if (isdigit((int)c))
      return c - '0';
   else if (islower((int)c))
      return 10 + c - 'a';
   else
      return 10 + c - 'A';
}

/* Stack  
 * This is a stack implemented with linked-list. 
 */
struct stack_st {
   unsigned char c;
   struct stack_st* rest;
};
typedef struct stack_st* stack_t;

static
const stack_t EMPTY_STACK = NULL;

/* Push
 *
 * Note that stack_t is actually a pointer.  
 */
static 
void push(stack_t* stack, unsigned char c) {
   stack_t top =  malloc(sizeof(struct stack_st));
   top->rest = *stack;
   top->c = c;
   *stack = top;
}

/* Peek
 *
 * Look at without removing the top of the stack.  This is a non-standard,
 * helper function that could be implemented with a pop-look-push sequence.
 */
static
unsigned char peek(stack_t* stack) {
   assert (stack != NULL && *stack != NULL);
   return (*stack)->c;
}

/* Pop
 *
 * Remove and return the top of the stack.
 */
static
unsigned char pop(stack_t* stack) {
   unsigned char c;
   stack_t top = *stack;

   assert (stack != NULL && *stack != NULL);

   *stack = top->rest;
   c = top->c;
   free(top);
   return c;
}

/* Release Stack
 * 
 * Free all allocated memory associated with this stack.
 */
static void release_stack(stack_t* stack) {
   while (*stack != EMPTY_STACK)
      pop(stack);
}

/* Read Natural
 * This function reads a natural number from source, which is probably the
 * console, returning a newly created natural number type.  Characters a read
 * one at a time until a non-hex character is found.
 *
 * Since we store thing little-endian, but write them out big-endian, we read
 * hex-digits from the source one character at a time and push them onto a
 * stack.  Okay, we skip leading spaces and zeros.
 *
 * Now we know how many hex-digits we have, we need half (rounded-up) bytes to
 * store them.  We then combine the hex-digits two at a time into bytes in
 * little-endian format.  This could, of course, leave one nibble left over.  I
 * handle that as a special case.
 */
natural_t read_natural(FILE* source)
{
   char c;
   unsigned i;
   unsigned char a, b;
   natural_t nat = {0,0};
   unsigned length = 0;
   stack_t stack = EMPTY_STACK;

   assert (source != NULL);

   c = getc(source);
   while (c != EOF && (isspace((int)c) || c == '0')) 
      c = getc(source);

   while (c != EOF && isxdigit((int)c)) {
      push(&stack, hex_to_value(c));
      ++length;
      c = getc(source);
   }

   if (c != EOF)
      ungetc(c, source);

   nat.byte_count = (length + 1) / 2;
   if (nat.byte_count > 0) {
      nat.bytes = (unsigned char*) malloc (nat.byte_count);
      
      i = 0;
      while (length > 1) {
         length -= 2;
         a = pop(&stack);
         b = pop(&stack);
         
         nat.bytes[i] = (b << 4) + a;
         i++;
	 
      }
      //changed the length comparison from 0 to 1 to stop infinite loop with peek()
      while (length > 1) {
         nat.bytes[i] = peek(&stack);
      }
   }

   release_stack(&stack);

   return nat;
}

/* Print Natural
 * This function prints the natural number to the destination, which is probably
 * the console.  The number is printed in hex.
 */
void print_natural(FILE* destination, natural_t natural)
{
   unsigned i = natural.byte_count - 1;
  
   if (natural.byte_count > 0){
      printf("%x", natural.bytes[i]);
      //removed = sign to prevent stack overflow, moved for loop inside if to not overwrite else, and -1 from i to start at the proper index in memory.
      for (; i > 0; --i){
         printf("%02x", natural.bytes[i-1]);
      }

   }else{
      printf("0");
   }
    
}
