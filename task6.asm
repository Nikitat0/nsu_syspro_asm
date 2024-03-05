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
    call div10
    call print_number
    li a0, 0xa
    printch
    mv a0, s1
    call mod10
    call print_number
exit:
    exit

mul10:
    add t0, a0, a0
    slli a0, a0, 3
    add a0, a0, t0
    ret

div10_less_than_10:
    mv a0, zero
    ret
div10:
    slti t0, a0, 10
    bne zero, t0, div10_less_than_10

    addi sp, sp, -8
    sw ra, 0(sp)
    sw s1, 4(sp)
    mv s1, a0

    srli a0, a0, 1
    call div10
    srli a1, s1, 2
    sub a0, a1, a0
    srli a0, a0, 1

    lw ra, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret

mod10:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s1, 4(sp)

    mv s1, a0
    call div10
    call mul10
    sub a0, s1, a0

    lw ra, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret


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
