.include "lib_core.asm"
.include "lib_dec.asm"
.include "lib_math.asm"

.text
main:
    call scan_number
    call usqrt
    call print_number
