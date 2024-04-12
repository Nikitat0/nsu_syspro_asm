.text
umul: # unsigned int umul(unsigned int a, unsigned int b)
    mv t0, zero
    mv t1, zero
umul_1:
    andi t2, a1, 1
    addi t2, t2, -1
    not t2, t2
    sll t3, a0, t0
    and t2, t2, t3
    add t1, t1, t2

    addi t0, t0, 1
    srli a1, a1, 1
    bne zero, a1, umul_1
    mv a0, t1
    ret

udiv: # unsigned int udiv(unsigned int a, unsigned int b)
    beqz a1, zero_division_error
    li a2, 0
    li a3, 33
    mv t0, a1
udiv_1:
    srli t0, t0, 1
    addi a3, a3, -1
    bnez t0, udiv_1
udiv_2:
    addi a3, a3, -1
    slli a2, a2, 1
    sll t0, a1, a3
    sltu t1, a0, t0
    xori t1, t1, 1
    xor a2, a2, t1
    neg t1, t1
    and t0, t0, t1
    sub a0, a0, t0
    bnez a3, udiv_2
    mv a0, a2
    ret
zero_division_error:
    error "Zero division error"

