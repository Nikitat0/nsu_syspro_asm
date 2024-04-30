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

udiv: # (unsigned int, unsigned int) udiv(unsigned int a, unsigned int b)
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
    mv a1, a0
    mv a0, a2
    ret
zero_division_error:
    error "Zero division error"

sdiv: # int sdiv(int a, int b)
    push2 ra, s1
    slt t0, a0, zero
    slt t1, a1, zero
    xor s1, t0, t1

    addi t0, t0, -1
    add t3, a0, a0
    and t3, t0, t3
    sub a0, t3, a0

    addi t1, t1, -1
    add t3, a1, a1
    and t3, t1, t3
    sub a1, t3, a1

    call udiv
    snez a1, a1
    addi s1, s1, -1
    add t0, a0, a0
    and t0, s1, t0
    add a0, a0, a1
    sub a0, t0, a0
    pop2 ra, s1
ret

usqrt: # unsigned int usqrt(unsigned int x)
    li a1, 0
    li a2, 0
    li a3, 16
usqrt_1:
    addi a3, a3, -1
    slli a2, a2, 2
    srli t0, a0, 30
    or a2, a2, t0
    slli a0, a0, 2
    slli a1, a1, 1
    slli t0, a1, 1
    addi t0, t0, 1
    sltu t1, a2, t0
    xori t1, t1, 1
    xor a1, a1, t1
    neg t1, t1
    and t0, t0, t1
    sub a2, a2, t0
    bnez a3, usqrt_1
    mv a0, a1
ret

ucbrt: # unsigned int ucbrt(unsigned int x)
    push4 ra, s1, s2, s3
    mv s1, a0

    srli t0, s1, 30
    snez s2, t0
    slli t0, s2, 30
    sub s1, s1, t0

    li s3, 30 # int iterations
ucbrt_1:
    addi s3, s3, -3
    mv a0, s2
    slli s2, s2, 1
    add a0, s2, a0
    addi a1, s2, 1
    call umul
    slli a0, a0, 1
    addi a0, a0, 1
    sll a0, a0, s3
    sltu t0, s1, a0
    xori t0, t0, 1
    or s2, s2, t0
    neg t0, t0
    and a0, a0, t0
    sub s1, s1, a0
    bnez s3, ucbrt_1
    mv a0, s2
    pop4 ra, s1, s2, s3
ret
