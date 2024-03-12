.macro to_digit %rd, %rs
    addi a0, a0, '0'
.end_macro

.macro mul10 %rd, %rs # caller-saved: t0
    add t0, %rs, %rs
    slli %rd, %rs, 3
    add %rd, %rd, t0
.end_macro

.text
from_digit: # int from_digit(char c)
    addi a0, a0, -48 # -'0'
    sltiu t0, a0, 10
    beqz t0, from_digit_error
    ret
from_digit_error:
    error "Invalid hex digit"

div10: # int div10(unsigned int x)
    sltiu t0, a0, 10
    bne zero, t0, div10_lt_10
    push2 ra, s1
    mv s1, a0
    srli a0, a0, 1
    call div10
    srli a1, s1, 2
    sub a0, a1, a0
    srli a0, a0, 1
    mul10 a2, a0
    sltu t0, s1, a2
    sub a0, a0, t0
    pop2 ra, s1
    ret
div10_lt_10:
    mv a0, zero
    ret

mod10: # int mod10(unsigned int x)
    push2 ra, s1
    mv s1, a0
    call div10
    mul10 a0, a0
    sub a0, s1, a0
    pop2 ra, s1
    ret

scan_number: # int scan_number()
    push3 ra, s1, s2
    li s1, 0
    readch
    xori s2, a0, '-'
    bnez s2, scan_number_1
    readch
scan_number_1:
    li t0, 214748364 # floor((2^31-1)/10)
    bltu t0, s1, scan_number_error
    call from_digit
    mul10 s1, s1
    add s1, s1, a0
    blt s1, zero, scan_number_error
    readch
    xori t0, a0, 0xa # "\n"
    bnez t0, scan_number_1
    mv a0, s1
    bnez s2, scan_number_2
    neg a0, a0
scan_number_2:
    pop3 ra, s1, s2
    ret
scan_number_error:
    error "Too big number"

print_number: # void print_number(int n)
    push3 ra, fp, s1
    mv fp, sp
    bge a0, zero, print_number_1
    mv s1, a0
    li a0, '-'
    printch
    neg a0, s1
print_number_1:
    mv s1, a0
    call mod10
    to_digit a0, a0
    push a0
    mv a0, s1
    call div10
    bne zero, a0, print_number_1
print_number_2:
    pop a0
    printch
    bne sp, fp, print_number_2
    pop3 ra, fp, s1
    ret
