extern close
extern dalloc
extern lseek
extern open
extern read
extern strlen
extern write

global O_RDONLY, O_WRONLY, O_RDWR, O_CREAT, O_TRUNC
O_RDONLY equ 0
O_WRONLY equ 1
O_RDWR equ 2
O_RDWR equ 2
O_CREAT equ 0o100
O_TRUNC equ 0o1000

func fopen ; int fopen(const char *path, int mode)
    mov rdx, 0o0644
    call open wrt ..plt
    test eax, eax
    js .err
ret
    .err perror "fopen"

func fread ; int fread(int fd, void *buf, size_t nbyte)
    call read wrt ..plt
    cmp eax, -1
    jz .err
ret
    .err perror "fread"

func fwrite ; int fwrite(int fd, void *buf, size_t nbyte)
    call write wrt ..plt
    cmp eax, -1
    jz .err
ret
    .err perror "fwrite"

global SEEK_SET, SEEK_CUR, SEEK_END
SEEK_SET equ 0
SEEK_CUR equ 1
SEEK_END equ 2

func fseek ; int fwrite(int fd, int offset, int whence)
    call lseek wrt ..plt
    cmp eax, -1
    jz .err
ret
    .err perror "fseek"

func fclose ; void close(int fd)
    call close wrt ..plt
    test eax, eax
    jnz .err
ret
    .err perror "fclose"

func flength ; size_t flength(int fd)
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

func fload ; char *fload(int fd)
    push rdi ; [rsp + 8]: int fd
    sub rsp, 16
    call flength
    mov [rsp], rax ; [rsp]: size_t len
    lea rdi, [rax + 1]
    call dalloc
    mov rdi, [rsp + 16]
    mov rsi, rax
    mov rdx, [rsp]
    mov byte [rsi + rdx + 1], 0
    mov [rsp], rsi
    call fread
    pop rax
    add rsp, 16
ret

func fwriteline ; void *fwriteline(int fd, const char *line)
    sub rsp, 8
    push rsi
    push rdi
    
    mov rdi, rsi
    call strlen

    mov rdi, [rsp]
    mov rsi, [rsp + 8]
    mov rdx, rax
    call fwrite

    pop rdi
    lea rsi, [newline]
    xor edx, edx
    inc edx
    add rsp, 16
jmp fwrite

func fwritelines ; void *fwritelines(int fd, const char *lines, size_t nlines)
    test rdx, rdx
    jz .skip
    push rbx
    lea rax, [rsi + 8 * rdx]
    push rax
    mov rbx, rsi

    .loop:
    push rdi
    mov rsi, [rbx]
    call fwriteline
    pop rdi
    lea rbx, [rbx + 8]
    cmp rbx, [rsp]
    jne .loop

    add rsp, 8
    pop rbx
    .skip:
ret

section .rodata
    newline: db `\n`
