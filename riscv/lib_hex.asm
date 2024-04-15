.text
from_hex_digit: # int from_hex_digit(char c)
    ori a0, a0, 0x20 # 'A' -> 'a'
    addi a0, a0, -48 # -'0'
    sltiu t0, a0, 10
    neg t0, t0
    and t1, a0, t0
    addi a0, a0, -49 # -'a' + '0'
    sltiu t2, a0, 6
    neg t2, t2
    addi a0, a0, 10
    and a0, a0, t2
    add a0, a0, t1
    or t0, t0, t2
    beqz t0, from_hex_digit_error
    ret
from_hex_digit_error:
    error "Invalid hex digit"

to_hex_digit: # char to_hex_digit(int n)
    sltiu t0, a0, 10
    addi t0, t0, -1
    andi t0, t0, 39 # 'a' - '0' - 10
    addi a0, a0, 48 # '0'
    add a0, a0, t0
    ret

scan_hex_number: # int scan_hex_number()
    push2 ra, s1
    li s1, 0
    readch
scan_hex_number_1:
    srli t0, s1, 28
    andi t0, t0, 0xF
    bnez t0, scan_hex_number_error
    slli s1, s1, 4
    call from_hex_digit
    or s1, s1, a0
    readch
    xori t0, a0, 0xa # "\n"
    bnez t0, scan_hex_number_1
    mv a0, s1
    pop2 ra, s1
    ret
scan_hex_number_error:
    error "Too big hex number"

print_hex_number: # void print_hex_number(int n)
    push3 ra, fp, s1
    mv fp, sp
    mv s1, a0
print_hex_number_1:
    andi a0, s1, 0xF
    call to_hex_digit
    push a0
    srli s1, s1, 4
    bne zero, s1, print_hex_number_1
print_hex_number_2:
    pop a0
    printch
    bne sp, fp, print_hex_number_2
    pop3 ra, fp, s1
    ret
