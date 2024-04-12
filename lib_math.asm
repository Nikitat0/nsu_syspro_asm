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
