.include "lib_core.asm"
.include "lib_dec.asm"

.text
main:
    call scan_number
    call print_number
    exit 0
