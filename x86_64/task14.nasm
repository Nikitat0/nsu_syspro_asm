section .text
extern clap
extern fopen
extern fload
extern fclose
extern lower
extern print_char
extern print_int
extern print_newline
extern print_string
extern strstr
extern splitlines

global main
main:
    push qword [shopt_mask]
    sub rsp, 8 ; [rsp + 8]: options_t options

    mov rdi, rsi
    mov rsi, rsp
    lea rdx, [rsp + 8]
    call clap
    cmp qword [rsp], 2
    jne .print_usage
    mov rdi, [rax + 8]
    mov rax, [rax]
    mov [rsp], rax ; [rsp]: char *pattern

    mov rsi, [rsp + 8]
    call grep_load

    mov rdi, rax
    mov rsi, [rsp]
    mov rdx, [rsp + 8]
    call grep
    mov [rsp], rax ; [rsp]: size_t c

    testopt qword [rsp + 8], 'c'
    jz .skip_print_c
    mov rdi, rax
    call print_int
    call print_newline
    .skip_print_c:

    mov rax, [rsp]
    test rax, rax
    setz al
    movsx eax, al

    add rsp, 16
    ret
    .print_usage:
    lea rdi, [usage]
    call print_string
    exit -1

grep_load: ; char *grep_load(char *path, options_t options)
    push rsi
    sub rsp, 16 ; [rsp + 16] options_t options

    call fopen
    mov [rsp], rax ; [rsp]: int fd
    mov rdi, rax
    call fload
    mov rdi, [rsp] 
    mov [rsp], rax ; [rsp]: char *content
    call fclose

    testopt qword [rsp + 16], 'i'
    jz .skip_lower
    mov rdi, [rsp]
    call lower
    .skip_lower:

    pop rax
    add rsp, 16
    ret

grep: ; size_t *grep(char *content, char *pattern, options_t options)
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    push rsi ; [rbp - 8]: char *pattern
    push rdx ; [rbp - 16]: options_t options
    push 0 ; [rbp - 24]: size_t nlines
    push 0 ; [rbp - 32]: size_t c

    lea rsi, [rbp - 24]
    call splitlines
    mov rbx, rax ; rbx: char* lines[]
    xor r12, r12

    jmp .loop_begin
    .loop:
    mov rdi, [rbx + 8 * r12]
    mov rsi, [rbp - 8]
    call strstr
    test rax, rax
    setnz al
    testopt qword [rbp - 16], 'v'
    setnz dl
    xor al, dl
    jz .no_match
    inc qword [rbp - 32]
    testopt qword [rbp - 16], 'c'
    jnz .skip_print
    testopt qword [rbp - 16], 'n'
    jz .skip_n
    lea rdi, [r12 + 1]
    call print_int
    .skip_n:
    mov edi, ' '
    call print_char
    mov rdi, [rbx + 8 * r12]
    call print_string
    call print_newline
    .skip_print:
    .no_match:
    inc r12
    .loop_begin:
    cmp r12, [rbp - 24]
    jne .loop
    
    pop rax
    leave
    pop r12
    pop rbx
    ret

section .rodata
usage:
    db "usage: grep PATTERN FILE [-cinv]", 10, 0
shopt_mask:
    doptions 'c', 'i', 'n', 'v'
