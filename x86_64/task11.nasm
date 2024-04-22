default rel

section .text
extern fopen
extern flength
extern fread
extern fclose
extern O_RDONLY
extern print_string
extern print_int
extern print_newline
extern dalloc

global main
main:
    cmp rdi, 2
    jnz .print_usage

    mov rdi, [rsi + 8]
    push rdi ; const char *path
    mov rsi, O_RDONLY
    call fopen
    push rax ; int fd

    mov rdi, rax
    call flength
    push rax ; size_t len

    lea rdi, [rax + 1]
    call dalloc
    mov r10, [rsp]
    mov QWORD [rax + r10 + 1], 0

    mov rdi, [rsp + 8]
    mov rsi, rax
    mov rdx, [rsp]
    call fread

    mov rdi, [rsp + 16]
    call print_string
    lea rdi, [name_len_sep]
    call print_string
    mov rdi, [rsp]
    call print_int
    call print_newline

    mov rdi, [rsp + 8]
    call fclose

    add rsp, 24
    xor eax, eax
    ret
    .print_usage: lea rdi, [usage]
    call print_string
    mov edi, -1
    ret

section .rodata
name_len_sep:
    db ": ", 0
usage:
    db "usage: task11 PATH/TO/FILE", 10, 0
