.include "lib_core.asm"
.include "lib_core2.asm"
.include "lib_alloc.asm"
.include "lib_io.asm"

.text
main:
    li t0, 1
    bne t0, a0, incorrect_number_of_arguments
    lw a0, 0(a1)
    li a1, FILE_READONLY
    call fopen
    mv s1, a0
    call fload
    swap s1, a0
    close
    mv a0, s1
    print_string
    exit 0
incorrect_number_of_arguments:
    error "Incorrect number of arguments"
