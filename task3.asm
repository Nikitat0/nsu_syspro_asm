.include "lib1.asm"

.macro parse_digit
    addi a0, a0, -48 # -'0'
    sltiu t0, a0, 10
    addi, t0, t0, -1
    not t0, t0
    and a1, a0, t0

    addi a0, a0, 48
    ori a0, a0, 0x20
    addi a0, a0, -97
    sltiu t1, a0, 6
    addi t1, t1, -1
    not t1, t1
    addi a0, a0, 10
    and a0, a0, t1
    add a0, a0, a1
    xor t0, t0, t1
    beq zero, t0, exit
.end_macro

.macro to_digit
    sltiu t0, a0, 10
    addi t0, t0, -1
    not t1, t0
    and t1, t1, a0
    addi a0, a0, 7 # 'A' - '0' - 10
    and a0, a0, t0
    add a0, a0, t1
    addi a0, a0, 48 # '0'
.end_macro

main:
    call read_number
    mv s1, a0
    call read_number
    mv s2, a0

    readch
    xori t1, a0, '+'
    xori t2, a0, '-'
    xori t3, a0, '&'
    xori t4, a0, '|'
    slt t1, zero, t1
    slt t2, zero, t2
    slt t3, zero, t3
    slt t4, zero, t4
    addi t1, t1, -1
    addi t2, t2, -1
    addi t3, t3, -1
    addi t4, t4, -1

    add t0, s1, s2
    and a0, t0, t1
    sub t0, s1, s2
    and t0, t0, t2
    add a0, a0, t0
    and t0, s1, s2
    and t0, t0, t3
    add a0, a0, t0
    or t0, s1, s2
    and t0, t0, t4
    add a0, a0, t0

    or t0, t1, t2
    or t0, t0, t3
    or t0, t0, t4
    beq zero, t0, exit

    call print_number
exit:
    exit

read_number:
    addi sp, sp, -4
    sw s1, 0(sp)
    li s1, 0
read_number_1:
    readch
    xori t1, a0, ' '
    beq zero, t1, read_number_2
    slli s1, s1, 4
    mv s2, ra
    parse_digit
    mv ra, s2
    add s1, s1, a0
    srai t1, s1, 28
    andi t1, t1, 0xF
    beq zero, t1, read_number_1
read_number_2:
    mv a0, s1
    lw s1, 0(sp)
    addi sp, sp, 4
    ret

print_number:
    addi sp, sp, -4
    sw s1, 0(sp)
    sw s2, 4(sp)
    mv s1, sp
    mv s2, a0
print_number_1:
    andi a0, s2, 0xF
    to_digit
    addi sp, sp, -1
    sb a0, 0(sp)
    srli s2, s2, 4
    bne zero, s2, print_number_1
print_number_2:
    lb a0, 0(sp)
    addi sp, sp, +1
    printch
    bne sp, s1, print_number_2

    lw s1, 0(sp)
    lw s2, 4(sp)
    addi sp, sp, +4
    ret
