.include "lib1.asm"

.macro parse_digit
    addi a0, a0, -48 # -'0'
    sltiu t0, a0, 10
    beq zero, t0, exit
.end_macro

.macro to_digit
    addi a0, a0, '0'
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
    slt t1, zero, t1
    slt t2, zero, t2
    addi t1, t1, -1
    addi t2, t2, -1

    add t0, s1, s2
    and a0, t0, t1
    sub t0, s1, s2
    and t0, t0, t2
    add a0, a0, t0

    or t0, t1, t2
    beq zero, t0, exit

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
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s1, 4(sp)
    li s1, 0
read_number_1:
    readch
    xori t0, a0, ' '
    beq zero, t0, read_number_2
    parse_digit
    mv s2, a0
    mv a0, s1
    call mul10
    add s1, a0, s2
    j read_number_1
read_number_2:
    mv a0, s1
    lw ra, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret

print_number:
    addi sp, sp, -12
    sw s1, 0(sp)
    sw fp, 4(sp)
    sw ra, 8(sp)
    mv fp, sp
print_number_1:
    mv s1, a0
    call mod10
    addi sp, sp, -4
    sw a0, 0(sp)
    mv a0, s1
    call div10
    bne zero, a0, print_number_1
print_number_2:
    lw a0, 0(sp)
    to_digit
    printch
    addi sp, sp, 4
    xor t0, fp, sp
    bne zero, t0, print_number_2

    lw s1, 0(sp)
    lw fp, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    ret
