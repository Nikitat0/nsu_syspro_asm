.macro bcd_abs %rd, %rs
    srli %rd, %rs, 4
.end_macro

.text
from_bcd_digit: # int from_bcd_digit(int c)
    addi a0, a0, -48 # -'0'
    sltiu t0, a0, 10
    beqz t0, from_bcd_digit_error
    ret
from_bcd_digit_error:
    error "Invalid digit"

normalize_bcd: # int normalize_bcd(int bcd)
    srli t0, a0, 4
    seqz t0, t0
    not t0, t0
    and a0, a0, t0
    ret

scan_bcd_number: # int scan_bcd_number()
    push3 ra, s1, s2
    li s1, 0
    li s2, 0xa
    readch
    xori t0, a0, '-'
    seqz t0, t0
    add s2, s2, t0
    beqz t0, scan_bcd_number_1
    readch
scan_bcd_number_1:
    srli t0, s1, 24
    andi t0, t0, 0xF
    bnez t0, scan_bcd_number_error
    slli s1, s1, 4
    call from_bcd_digit
    or s1, s1, a0
    readch
    xori t0, a0, 0xa # "\n"
    bnez t0, scan_bcd_number_1
    slli a0, s1, 4
    or a0, a0, s2
    call normalize_bcd
    pop3 ra, s1, s2
    ret
scan_bcd_number_error:
    error "Too big number"

print_bcd_number: # void print_bcd_number(int bcd)
    push3 ra, fp, s1
    mv fp, sp
    srli s1, a0, 4
    andi a0, a0, 0x1
    beqz a0, print_bcd_number_1
    li a0, '-'
    printch
print_bcd_number_1:
    andi a0, s1, 0xF
    addi a0, a0, '0'
    push a0
    srli s1, s1, 4
    bne zero, s1, print_bcd_number_1
print_bcd_number_2:
    pop a0
    printch
    bne sp, fp, print_bcd_number_2
    pop3 ra, fp, s1
    ret
