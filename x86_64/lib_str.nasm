extern dalloc

func strchr ; const char *strchr(const char *str, char ch)
    .loop:
    movzx eax, byte [rdi]
    cmp eax, esi
    jz .found
    inc rdi
    test eax, eax
    jnz .loop
    ret
    .found:
    mov rax, rdi
    ret

func splitlines ; char **splitlines(char *str, size_t *nlines)
    push rbp
    mov rbp, rsp
    
    .loop:
    movzx eax, byte [rdi]
    test al, al
    jz .skip_loop
    push rdi
        .loop2:
        movzx eax, byte [rdi]
        test eax, eax
        jz .skip_loop
        inc rdi
        cmp eax, 10 ; \n
        jne .loop2
    mov byte [rdi - 1], 0
    jmp .loop
    .skip_loop:

    mov rdi, rbp
    sub rdi, rsp
    and rsp, -16
    push rdi
    push rsi
    call dalloc
    pop rdi
    pop rdx

    shr rdx, 3
    mov [rdi], rdx

    lea rsi, [rbp - 8]
    xor ecx, ecx
    .loop3:
    mov rdi, [rsi]
    mov [rax + 8 * rcx], rdi
    sub rsi, 8
    inc rcx
    cmp rcx, rdx
    jne .loop3

    leave
    ret

func atou ; uint64_t atou(const char *)
    mov cl, byte [rdi]
    test cl, cl
    jz .on_empty
    xor eax, eax
    mov ecx, 10
    .loop:
    mul rcx
    jb .on_overflow
    mov dl, byte [rdi]
    sub dl, '0'
    cmp dl, 10
    ja .on_unexpected
    add rax, rdx
    jb .on_overflow
    inc rdi
    mov dl, byte [rdi]
    test dl, dl
    jnz .loop
    ret
    .on_empty error "atou: Empty"
    .on_unexpected error "atou: Unexpected character"
    .on_overflow error "atou: Overflow"
