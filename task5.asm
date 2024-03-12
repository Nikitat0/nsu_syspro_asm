.include "lib_core.asm"
.include "lib_dec.asm"
.include "lib_mul.asm"

.text
main:
    call read_number
    mv s1, a0
    call read_number
    mv a1, a0
    mv a0, s1
    call mul
    call print_number
    exit 0
