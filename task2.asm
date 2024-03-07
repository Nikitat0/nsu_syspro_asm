.include "lib_core.asm"

main:
    readch
    li t0 '\n'
    beq a0, t0, exit
    addi s1, a0, 1
    printch
    mv a0, s1
    printch
    j main

exit:
    exit 0
