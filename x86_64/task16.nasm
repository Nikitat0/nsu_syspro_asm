extern dalloc
extern fopen
extern fload
extern fwritelines
extern fclose
extern O_RDONLY
extern O_WRONLY
extern O_CREAT
extern O_TRUNC
extern print_string
extern strcat
extern strcpy
extern strlen
extern sort_strs
extern splitlines

global main
main:
    cmp rdi, 2
    jne .print_usage

    push rbp
    mov rbp, rsp
    mov rdi, [rsi + 8]
    push rdi ; [rbp - 8]: char *path
    sub rsp, 24

    mov rsi, O_RDONLY
    call fopen
    mov [rbp - 16], rax ; [rbp - 16]: int fd

    mov rdi, rax
    call fload
    mov rdi, [rbp - 16]
    mov [rbp - 16], rax ; [rbp - 16]: char *content

    call fclose

    mov rdi, [rbp - 16]
    lea rsi, [rbp - 24]
    call splitlines
    mov [rbp - 16], rax ; [rbp - 16] char *lines[]
    ; [rbp - 24] size_t nlines

    mov rdi, [rbp - 8]
    call strlen

    lea rdi, [rax + 7 + 1]
    call dalloc

    mov rdi, rax
    mov rsi, [rbp - 8]
    call strcpy

    mov rdi, rax
    lea rsi, [dot_sorted]
    call strcat

    mov rdi, rax
    mov rsi, O_WRONLY 
    mov rax, O_CREAT
    or rsi, rax
    mov rax, O_TRUNC
    or rsi, rax
    call fopen
    mov [rbp - 8], rax ; [rbp - 8] int fd

    mov rdi, [rbp - 16]
    mov rsi, [rbp - 24]
    call sort_strs

    mov rdi, [rbp - 8]
    mov rsi, [rbp - 16]
    mov rdx, [rbp - 24]
    call fwritelines

    mov rdi, [rbp - 8]
    call fclose

    xor eax, eax
    leave
ret
    .print_usage:
    lea rdi, [usage]
    call print_string
    exit -1

section .rodata
usage:
    db "usage: task16 FILE", 10, 0
dot_sorted:
    db ".sorted"
