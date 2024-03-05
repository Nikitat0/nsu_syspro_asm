.include "lib1.asm"

.macro parse_digit
    addi a0, a0, -48 # -'0'
    sltiu t0, a0, 10
    beq zero, t0, exit
.end_macro

.macro to_digit
    addi a0, a0, '0'
.end_macro

main:
    call read_number
    mv s1, a0
    call read_number
    mv s2, a0
    readch
    mv a2, a0
    mv a0, s1
    mv a1, s2
    xori t0, a2, '+'
    beq zero, t0, main_add
    xori t0, a2, '-'
    beq zero, t0, main_sub
exit:
    exit
main_add:
    call add
    call print_number
    exit
main_sub:
    call sub
    call print_number
    exit

add:
    li a2, 0 # result
    li a3, 0 # shift
    li a4, 0 # carry
add_1:
    andi t0, a0, 0xf
    andi t1, a1, 0xf
    add t0, t0, t1
    add t0, t0, a4
    sltiu t1, t0, 10
    addi t1, t1, -1 # false mask
    andi a4, t1, 1
    andi t1, t1, 6
    add t0, t0, t1
    andi t0, t0, 0xf
    sll t0, t0, a3
    or a2, a2, t0

    srli a0, a0, 4
    srli a1, a1, 4
    addi a3, a3, 4
    or t0, a0, a1
    or t0, t0, a4
    bne zero, t0, add_1

    mv a0, a2
    ret

sub:
    li a2, 0 # result
    li a3, 0 # shift
    li a4, 0 # borrow
sub_1:
    andi t0, a0, 0xf
    andi t1, a1, 0xf
    add t1, t1, a4
    sltu a4, t0, t1
    neg t2, a4 # true mask
    andi t2, t2, 10
    add t0, t0, t2
    sub t0, t0, t1
    sll t0, t0, a3
    or a2, a2, t0

    srli a0, a0, 4
    srli a1, a1, 4
    addi a3, a3, 4
    or t0, a0, a1
    bne zero, t0, sub_1

    mv a0, a2
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
