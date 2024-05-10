extern close
extern dalloc
extern lseek
extern open
extern read
extern write

global O_RDONLY, O_WRONLY, O_RDWR
O_RDONLY equ 0
O_WRONLY equ 1
O_RDWR equ 2

func fopen ; int fopen(const char *path, int mode)
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
