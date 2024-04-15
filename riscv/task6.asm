.include "lib_core.asm"
.include "lib_dec.asm"

.text
main:
    call scan_number
    mv s1, a0
    call div10
    call print_number
    li a0, 0xa
    printch
    mv a0, s1
    call mod10
    call print_number
    exit 0
