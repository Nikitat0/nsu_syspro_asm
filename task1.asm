.include "lib1.asm"

main:
	readch
	addi a0, a0, -48 # -'0'
	sltiu a0, a0, 10
    beq zero, a0, main_exit
    li a0, '1'
    printch
	li a0, '\n'
	printch
main_exit:
    exit
