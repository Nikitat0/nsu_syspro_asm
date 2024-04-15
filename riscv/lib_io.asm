.macro open
    syscall 1024
.end_macro

.macro read
    syscall 63
.end_macro

.macro lseek
    syscall 62
.end_macro

.macro close
    syscall 57
.end_macro

.eqv FILE_READONLY 0
.eqv FILE_WRITEONLY 1
.eqv FILE_APPEND 9

.text
fopen: # int fopen(const char *path, int mode)
    open
    li t0, -1
    beq t0, a0, failed_to_open
    ret
failed_to_open:
    error "Failed to open file"

fread: # int fread(int fd, char *buffer, int size)
    read
    li t0, -1
    beq t0, a0, fread_error
    ret
fread_error:
    error "Failed to read file"

flength: # int flength(int fd)
    push s1
    mv s1, a0
    li a1, 0
    li a2, 2
    lseek
    li t0, -1
    beq t0, a0, flength_error
    swap a0, s1
    li a1, 0
    li a2, 0
    lseek
    li t0, -1
    beq t0, a0, flength_error
    mv a0, s1
    pop s1
    ret
flength_error:
    error "Failed to find length of file"

fload: # int fload(int f2)
    push3 ra, s1, s2
    mv s1, a0
    call flength
    mv s2, a0
    addi a0, a0, 1
    sbrk
    li t0, 0
    add t1, a0, s2
    sb t0, 1(t1)
    mv a1, a0
    mv a0, s1
    mv a2, s2
    mv s1, a1
    call fread
    mv a0, s1
    pop3 ra, s1, s2
    ret
