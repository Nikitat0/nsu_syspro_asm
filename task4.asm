.include "lib_core.asm"
.include "lib_bcd.asm"

.text
main:
    call scan_bcd_number
    mv s1, a0
    call scan_bcd_number
    mv s2, a0
    readch
    xori t0, a0, '+'
    beqz, t0, main_add
    xori t0, a0, '-'
    beqz, t0, main_sub
main_error:
    error "Invalid operation"
main_sub:
    xori s2, s2, 1
main_add:
    mv a0, s1
    mv a1, s2
    call bcd_add
    call print_bcd_number
    exit 0

bcd_add_sub:
    andi s1, a0, 1
    bcd_abs t0, a0
    bcd_abs t1, a1
    slt t2, t0, t1
    xor s1, s1, t2
    neg t2, t2
    xor a0, t0, t1
    and a0, a0, t2
    xor a1, a0, t1
    xor a0, a0, t0
    call ubcd_sub
    slli a0, a0, 4
    or a0, a0, s1
    call normalize_bcd
    j bcd_add_1
bcd_add: # bcd_t bcd_add(bcd_t lhs, bcd_t rhs)
    push2 ra, s1
    xor t0, a0, a1
    andi t0, t0, 1
    bnez t0, bcd_add_sub
    andi s1, a0, 1
    srli a0, a0, 4
    srli a1, a1, 4
    call ubcd_add
    slli a0, a0, 4
    or a0, a0, s1
bcd_add_1:
    ori a0, a0, 10
    pop2 ra, s1
    ret

ubcd_add: # ubcd_t ubcd_add(ubcd_t lhs, ubcd_t rhs)
    li a2, 0 # result
    li a3, 0 # shift
    li a4, 0 # carry
ubcd_add_1:
    andi t0, a0, 0xf
    andi t1, a1, 0xf
    add t0, t0, t1
    add t0, t0, a4
    sltiu t1, t0, 10
    addi t1, t1, -1
    andi a4, t1, 1
    andi t1, t1, -10
    add t0, t0, t1
    sll t0, t0, a3
    or a2, a2, t0
    srli a0, a0, 4
    srli a1, a1, 4
    addi a3, a3, 4
    or t0, a0, a1
    or t0, t0, a4
    bne zero, t0, ubcd_add_1
    mv a0, a2
    srli t0, a0, 28
    bnez t0, ubcd_add_overflow
    ret
ubcd_add_overflow:
    error "Overflow occured"

ubcd_sub: # ubcd_t ubcd_sub(ubcd_t lhs, ubcd_t rhs)
    li a2, 0 # result
    li a3, 0 # shift
    li a4, 0 # borrow
ubcd_sub_1:
    andi t0, a0, 0xf
    andi t1, a1, 0xf
    add t1, t1, a4
    sltu a4, t0, t1
    neg t2, a4
    andi t2, t2, 10
    add t0, t0, t2
    sub t0, t0, t1
    sll t0, t0, a3
    or a2, a2, t0
    srli a0, a0, 4
    srli a1, a1, 4
    addi a3, a3, 4
    or t0, a0, a1
    bne zero, t0, ubcd_sub_1
    mv a0, a2
    ret
