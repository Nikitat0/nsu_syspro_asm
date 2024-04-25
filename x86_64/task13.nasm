section .text
extern atou
extern dalloc
extern fopen
extern flength
extern fread
extern fclose
extern O_RDONLY
extern print_char
extern print_int
extern print_newline
extern print_string

global main
main:
    cmp rdi, 3
    ja .print_usage

    push rbx
    push rbp
    mov rbp, rsp
    sub rsp, 8 * 2

    mov rdx, [rsi + 8]
    mov [rbp - 8], rdx
    ; [rbp - 8]: const char *path

    mov qword [rbp - 16], -1
    cmp rdi, 2
    jz .skip_2nd_arg
    mov rdi, [rsi + 16]
    call atou
    mov [rbp - 16], rax
    test rax, rax
    jz .skip
    .skip_2nd_arg:
    ; [rbp - 16]: size_t n;

    mov rdi, [rbp - 8]
    mov rsi, O_RDONLY
    call fopen
    mov [rbp - 8], rax
    ; [rbp - 8]: int fd;

    mov rdi, rax
    call flength
    mov rbx, rax

    lea rdi, [rbx + 1]
    call dalloc
    lea rdi, [rax + rbx + 1]
    mov byte [rdi], 10

    mov rdi, [rbp - 8]
    mov rsi, rax
    mov rdx, rbx
    mov rbx, rax
    call fread

    xor rcx, rcx

    .loop_nl:
    mov al, [rbx]
    test al, al
    jz .eof

    push rbx
    inc rcx
    .loop:
    inc rbx
    mov al, [rbx - 1]
    test al, al
    jz .eof
    cmp al, 10
    jnz .loop
    mov byte [rbx - 1], 0
    jmp .loop_nl

    .eof:
    mov rbx, rcx
    mov rdi, [rbp - 8]
    call fclose

    mov rax, [rbp - 16]
    cmp rax, rbx
    cmova rax, rbx
    mov [rbp - 16], rbx
    sub [rbp - 16], rax
    lea rbx, [rsp + 8 * rax]
    ; [rbp - 16]: size_t strn

    .loop2:
    sub rbx, 8
    inc qword [rbp - 16]
    mov rdi, [rbp - 16]
    call print_int
    mov edi, ' '
    call print_char
    mov rdi, [rbx]
    call print_string
    call print_newline
    cmp rsp, rbx
    jnz .loop2

    .skip:
    xor eax, eax
    leave
    pop rbx
    ret
    .print_usage: lea rdi, [usage]
    call print_string
    exit -1

section .rodata
usage:
    db "usage: task13 PATH/TO/FILE [N]", 10, 0
