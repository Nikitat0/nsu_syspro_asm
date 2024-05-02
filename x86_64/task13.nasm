section .text
extern atou
extern dalloc
extern fopen
extern flength
extern fload
extern fread
extern fclose
extern O_RDONLY
extern print_char
extern print_int
extern print_newline
extern print_string
extern splitlines

global main
main:
    cmp rdi, 3
    ja .print_usage
    cmp rdi, 2
    jb .print_usage

    push rbx
    push r12
    push rbp
    mov rbp, rsp
    
    mov rax, [rsi + 8]
    mov rbx, rax ; rbx: char *path

    xor r12, r12
    dec r12
    cmp rdi, 2
    je .no_2nd_arg
    mov rdi, [rsi + 16]
    call atou
    mov r12, rax
    .no_2nd_arg:
    ; r12: size_t n

    mov rdi, rbx
    mov rsi, O_RDONLY
    call fopen
    mov rbx, rax ; rbx: int fd
    mov rdi, rax
    call fload
    mov rdi, rbx
    mov rbx, rax ; rbx: char *content
    call fclose

    mov rdi, rbx
    lea rsi, [rsp - 16]
    mov rsp, rsi
    call splitlines
    mov rbx, rax ; rbx: char *lines[]
    mov rdi, [rsp]
    mov [rsp], r13
    mov r13, rdi
    sub rdi, r12
    mov r12, 0
    cmovns r12, rdi

    jmp .loop_begin
    .loop:
    call print_char
    mov rdi, r12
    call print_int
    mov edi, ' '
    call print_char
    mov rdi, [rbx + 8 * r12]
    call print_string
    call print_newline
    inc r12
    .loop_begin:
    cmp r12, r13
    jne .loop

    leave
    pop r12
    pop rbx
    ret
    .print_usage: lea rdi, [usage]
    call print_string
    exit -1

section .rodata
usage:
    db "usage: task13 PATH/TO/FILE [N]", 10, 0
