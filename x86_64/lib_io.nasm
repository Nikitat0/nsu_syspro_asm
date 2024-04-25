section .text
extern close
extern lseek
extern open
extern read
extern write

global O_RDONLY, O_WRONLY, O_RDWR
O_RDONLY equ 0
O_WRONLY equ 1
O_RDWR equ 2

global fopen ; int fopen(const char *path, int mode)
fopen:
    call open wrt ..plt
    test eax, eax
    js .err
    ret
    .err perror "fopen"

global fread ; int fread(int fd, void *buf, size_t nbyte)
fread:
    call read wrt ..plt
    cmp eax, -1
    jz .err
    ret
    .err perror "fread"

global fwrite ; int fwrite(int fd, void *buf, size_t nbyte)
fwrite:
    call write wrt ..plt
    cmp eax, -1
    jz .err
    ret
    .err perror "fwrite"

global SEEK_SET, SEEK_CUR, SEEK_END
SEEK_SET equ 0
SEEK_CUR equ 1
SEEK_END equ 2

global fseek ; int fwrite(int fd, int offset, int whence)
fseek:
    call lseek wrt ..plt
    cmp eax, -1
    jz .err
    ret
    .err perror "fseek"

global fclose ; void close(int fd)
fclose:
    call close wrt ..plt
    test eax, eax
    jnz .err
    ret
    .err perror "fclose"

global flength ; size_t flength(int fd)
flength:
    push rdi
    xor rsi, rsi
    mov rdx, SEEK_SET
    call fseek
    push rax
    mov rdi, [rsp + 8]
    xor rsi, rsi
    mov rdx, SEEK_END
    call fseek
    push rax
    mov rdi, [rsp + 16]
    mov rsi, [rsp + 8]
    mov rdx, SEEK_SET
    call fseek
    pop rax
    add rsp, 16
    ret
