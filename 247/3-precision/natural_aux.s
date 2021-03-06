.text

        /* void add_naturals_aux(unsigned char* dst,
                                 unsigned char* src,
                                 int* carry);

        (1) The first and last sections of code simple create and destroy the
        stack frame.
        (2) Add the dst and src bytes 
        (3) Add in the carry argument
        Note: A new carry bit could be generated by either (2) or (3) but not
	both.  I'm using %cl to hold a cary from (2) and dl to hold carry from (3).
        (4) update the carry argument with the new carry status.
        */
        .global add_naturals_aux
add_naturals_aux:
        /* (1) */
        push  %rbp
        movq  %rsp, %rbp

        /* (2) */
        movb  (%rsi), %cl
        addb  %cl, (%rdi)
        setc  %cl

        /* (3) */
        movl  (%rdx), %eax
        addb  %al, (%rdi)
        setc  %al

        /* (4) */
        orb  %al, %cl
        movzbl %cl, %ecx
        movl  %ecx, (%rdx)

        leave
        ret
        
