.include "lib_core.asm"
.include "lib_dec.asm"
.include "lib_math.asm"

.text
main:
    call scan_number
    mv s1, a0 
    call usqrt
    call print_number
    li a0, 10
    printch
    mv a0, s1 
    call ucbrt
    call print_number
