
.include "lib_core.asm"
.include "lib_dec.asm"
.include "lib_math.asm"

.text
main:
    call scan_number
    mv s1, a0
    call scan_number
    mv a1, a0
    mv a0, s1
    call udiv
    call print_number
