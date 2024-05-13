extern clap
extern fopen
extern fload
extern flength
extern fclose
extern lower
extern O_RDONLY
extern print_char
extern print_int
extern print_newline
extern print_string
extern strlen
extern strspn
extern strcspn
extern splitlines

global main
main:
    push rbp
    mov rbp, rsp
    push qword [opt_mask]  ; [rbp - 8]: options_t options
    sub rsp, 40
    ; [rbp - 16]: char *path
    ; [rbp - 24]: size_t lines
    ; [rbp - 32]: size_t words
    ; [rbp - 40]: size_t bytes
    ; [rbp - 48]: size_t max_line_len

    mov rdi, rsi
    mov rsi, rsp
    lea rdx, [rbp - 8]
    call clap
    cmp qword [rsp], 1
    jne .print_usage

    mov rdi, [default_opts]
    mov rdx, [rbp - 8]
    test rdx, rdx
    cmovz rdx, rdi
    mov [rbp - 8], rdx

    mov rdi, [rax]
    mov rsi, O_RDONLY
    mov [rbp - 16], rdi
    call fopen
    mov [rbp - 24], rax ; [rbp - 24]: int fd
    
    mov rdi, rax
    call flength
    mov [rbp - 40], rax

    mov rdi, [rbp - 24]
    call fload
    mov [rbp - 48], rax ; [rbp - 48]: char *content

    mov rdi, [rbp - 24]
    call fclose

    mov rdi, [rbp - 48]
    call wc
    mov [rbp - 32], rax

    mov rdi, [rbp - 48]
    lea rsi, [rbp - 24]
    call splitlines
    mov [rbp - 48], rax ; [rbp - 48]: char *lines[]

    mov rdi, [rbp - 48]
    mov rsi, [rbp - 24]
    call max_len
    mov [rbp - 48], rax

    testopt qword [rbp - 8], 'l'
    jz .skip_l
    mov rdi, [rbp - 24]
    call print_int
    mov rdi, ' '
    call print_char
    .skip_l:

    testopt qword [rbp - 8], 'w'
    jz .skip_w
    mov rdi, [rbp - 32]
    call print_int
    mov rdi, ' '
    call print_char
    .skip_w:

    testopt qword [rbp - 8], 'c'
    jz .skip_c
    mov rdi, [rbp - 40]
    call print_int
    mov rdi, ' '
    call print_char
    .skip_c:

    mov rax, 1 << option('L')
    test qword [rbp - 8], rax
    jz .skip_L
    mov rdi, [rbp - 48]
    call print_int
    mov rdi, ' '
    call print_char
    .skip_L:

    mov rdi, [rbp - 16]
    call print_string
    call print_newline

    leave
ret
    .print_usage:
    lea rdi, [usage]
    call print_string
    exit -1

wc: ; size_t wc(const char *src)
    sub rsp, 8
    push rbx
    push r12
    mov rbx, rdi
    xor r12, r12
    dec r12

    .loop:
    inc r12
    mov rdi, rbx
    lea rsi, [whitespace_chars]
    call strspn
    add rbx, rax
    mov rdi, rbx
    lea rsi, [whitespace_chars]
    call strcspn
    add rbx, rax
    test rax, rax
    jnz .loop

    mov rax, r12
    pop r12
    pop rbx
    add rsp, 8
ret

max_len: ; size_t max_len(const char *lines[], size_t nlines)
    push rbx ; rbx: size_t nlines
    push r12 ; r12: const char *lines[]
    mov rbx, rsi
    mov r12, rdi

    test rsi, rsi
    jz .skip

    xor eax, eax
    .loop:
    push rax
    mov rdi, [r12 + 8 * rbx - 8]
    call strlen
    pop rdx
    cmp rax, rdx
    cmovb rax, rdx
    dec rbx
    jnz .loop
    
    .skip:
    pop r12
    pop rbx
ret

section .rodata
usage:
    db "usage: wc PATTERN FILE [-lwcL]", 10, 0
opt_mask:
    doptions 'c', 'l', 'L', 'w'
default_opts:
    doptions 'c', 'l', 'w'
whitespace_chars:
    db 0x9, 0xA, 0xB, 0xC, 0xD, 0x20, 0 ; "\t\n\v\f\r "
