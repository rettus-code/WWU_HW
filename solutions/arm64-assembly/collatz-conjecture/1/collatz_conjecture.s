.equ INVALID_NUMBER, -1

.text
.globl steps

steps:
        CMP x0, #0
        BEQ .invalid
        BLT .invalid

        MOV x1, x0
        MOV x0, 0
.next:
        CMP x1, 1
        BEQ .done

        ADD x0, x0, 1

        AND x2, x1, 1
        CBNZ x2, .odd
        B .even
        
.odd:
        MOV x3, 3
        MOV x2, 1
        MUL x1, x1, x3
        ADD x1, x1, x2
        B .next

.even: 
        LSR x1, x1, 1
        B .next
        
.invalid:
        MOV x0, INVALID_NUMBER
        B .done

.done:
        ret
