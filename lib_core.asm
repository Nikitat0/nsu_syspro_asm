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

.macro push3 %rs1, %rs2, %rs3
    addi sp, sp, -12
    sw %rs1, 0(sp)
    sw %rs2, 4(sp)
    sw %rs3, 8(sp)
.end_macro

.macro pop3 %rd1, %rd2, %rd3
    lw %rd1, 0(sp)
    lw %rd2, 4(sp)
    lw %rd3, 8(sp)
    addi sp, sp, 12
.end_macro

.macro swap %r1, %r2
    xor %r1, %r1, %r2
    xor %r2, %r1, %r2
    xor %r1, %r1, %r2
.end_macro

.eqv scratch a7

.macro _beqi %rs, %imm, %label
    li scratch, %imm
    beq %rs, scratch, %label
.end_macro

.macro _bnei %rs, %imm, %label
    li scratch, %imm
    bne %rs, scratch, %label
.end_macro
