.text
.globl reverse

reverse:
        MOV x1, x0

.find_end:
        LDRB w2, [x1], 1
        CMP w2, 0
        CBNZ w2, .find_end
        sub x1, x1, 2

.swap:
        CMP x0, x1
        BGE .finish
        LDRB w2, [x0]
        LDRB w3, [x1]
        STRB w3, [x0]
        STRB w2, [x1]
        ADD x0, x0, 1
        SUB x1, x1, 1
        B .swap
        
.finish:
        ret
