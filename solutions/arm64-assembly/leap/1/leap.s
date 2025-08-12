.text
.globl leap_year

leap_year:
        MOV x1, 0
        MOV x2, 3
        MOV x3, 100
        MOV x4, 400
        AND x9, x0, x2
        CBNZ x9, .is_not_leap_year
        MOV x1, 1
        B .is_100_or_400
        
.is_100_or_400:
        UDIV x10, x0, x3
        MSUB x9, x10, x3, x0
        CMP x9, 0
        B.NE .done
        B .is_400
        
.is_400:
        UDIV x10, x0, x4
        MSUB x9, x10, x4, x0
        CMP x9, 0
        B.EQ .is_leap_year
        B .is_not_leap_year

.is_leap_year:
        MOV x1, 1
        B .done
        
.is_not_leap_year:
        MOV x1, 0
        B .done
        
.done:
        MOV x0, x1
        ret
