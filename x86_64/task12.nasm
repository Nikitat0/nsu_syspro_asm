section .text
extern dalloc
extern fopen
extern flength
extern fread
extern fclose
extern O_RDONLY
extern print_int
extern print_newline
extern print_string
extern strchr

global main
main:
    cmp rdi, 2
    jnz .print_usage

    push rbx
    push rbp
    mov rbp, rsp
    sub rsp, 8 * 2

    mov rdi, [rsi + 8]
    mov rsi, O_RDONLY
    call fopen
    mov [rsp + 8], rax
    ; [rsp + 8]: int fd

    mov rdi, rax
    call flength
    mov [rsp], rax
    ; [rsp]: size_t len

    lea rdi, [rax + 1]
    call dalloc
    mov rdx, [rsp]
    mov byte [rax + rdx + 1], 0
    mov [rsp], rax
    ; [rsp]: char *buf

    mov rdi, [rsp + 8]
    mov rsi, rax
    call fread

    mov rdi, [rsp + 8]
    call fclose

    xor ebx, ebx
    mov rdi, [rsp]

    .loop:
    inc rbx
    mov rsi, 10
    call strchr
    lea rdi, [rax + 1]
    test rax, rax
    jnz .loop

    dec rbx
    mov rdi, rbx
    call print_int
    call print_newline

    xor eax, eax
    leave
    pop rbx
    ret
    .print_usage: lea rdi, [usage]
    call print_string
    exit -1

section .rodata
name_len_sep:
    db ": ", 0
usage:
    db "usage: task12 PATH/TO/FILE", 10, 0
