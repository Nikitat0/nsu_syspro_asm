.include "lib_core.asm"

main:
	readch
	addi a0, a0, -48 # -'0'
	sltiu a0, a0, 10
    beqz, a0, exit
    li a0, '1'
    printch

exit:
    exit 0
