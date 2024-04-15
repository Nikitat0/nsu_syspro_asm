.include "lib_core.asm"
.include "lib_hex.asm"

.text
main_add:
    add a0, s1, s2
    j main_1
main_sub:
    sub a0, s1, s2
    j main_1
main_and:
    and a0, s1, s2
    j main_1
main_or:
    or a0, s1, s2
    j main_1
main:
    call scan_hex_number
    mv s1, a0
    call scan_hex_number
    mv s2, a0

    readch
    xori t0, a0, '+'
    beqz t0, main_add
    xori t0, a0, '-'
    beqz t0, main_sub
    xori t0, a0, '&'
    beqz t0, main_and
    xori t0, a0, '|'
    beqz t0, main_or
    j main_error
main_1:
    call print_hex_number
    exit 0
main_error:
    error "Invalid operation"
