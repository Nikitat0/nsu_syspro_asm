_start:
    j main

.macro syscall %n
	li a7, %n
	ecall
.end_macro

.macro readch
	syscall 12
.end_macro

.macro printch
	syscall 11
.end_macro

.macro exit %status
    li a0, %status
	syscall 93
.end_macro

.macro error %msg
    .data
    error_msg:
    .string %msg
    .text
    la a0, error_msg
    syscall 4
    exit 1
.end_macro

.macro push %rs
    addi sp, sp, -4
    sw %rs, 0(sp)
.end_macro

.macro pop %rd
    lw %rd, 0(sp)
    addi sp, sp, 4
.end_macro

.macro push2 %rs1, %rs2
    addi sp, sp, -8
    sw %rs1, 0(sp)
    sw %rs2, 4(sp)
.end_macro

.macro pop2 %rd1, %rd2
    lw %rd1, 0(sp)
    lw %rd2, 4(sp)
    addi sp, sp, 8
.end_macro
