.include "lib_core.asm"
.include "lib_dec.asm"

.text
main_sub:
    neg s2, s2
main_add:
    add a0, s1, s2
    slti t0, s2, 0
    slt t1, a0, s1
    bne t0, t1, main_overflow
    li t0, -2147483647 # -(2^31 - 1)
    blt a0, t0, main_overflow
    call print_number
    exit 0
main:
    call scan_number
    mv s1, a0
    call scan_number
    mv s2, a0
    readch
    xori t0, a0, '+'
    beqz t0, main_add
    xori t0, a0, '-'
    beqz t0, main_sub
main_error:
    error "Invalid operation"
main_overflow:
    error "Overflow occured"
