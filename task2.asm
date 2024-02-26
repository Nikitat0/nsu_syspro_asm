.include "lib1.asm"

main:
    li s1 '\n'
    readch
    beq a0, s1, main_exit
    printch
    j main
main_exit:
    exit
