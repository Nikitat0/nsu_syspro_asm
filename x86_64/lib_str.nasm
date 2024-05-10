extern dalloc

func strcpy ; char *strcpy(char *restrict dest, const char *restrict src);
    mov rax, rdi
    xor ecx, ecx
    .loop:
    movzx edx, byte [rsi + rcx]
    mov [rdi + rcx], dl
    inc rcx
    test dl, dl
    jnz .loop
ret

func strcmp ; int strcmp(const char *lhs, const char *rhs)
    xor ecx, ecx
    .loop:
    movzx eax, byte [rdi + rcx]
    movzx edx, byte [rsi + rcx]
    test al, al
    jz .lhs_end
    inc rcx
    sub eax, edx
    jz .loop
ret
    .lhs_end:
    sub eax, edx
    ret

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

func strstr ; const char *strstr(const char *str, const char *substr)
    dec rsi
    .loop:
    lea rcx, [rdi - 1]
    mov rdx, rsi
        .loop2:
        inc rcx
        inc rdx
        mov al, [rdx]
        test al, al
        jz .found
        cmp al, byte [rcx]
        jz .loop2
    mov al, byte [rdi]
    inc rdi
    test al, al
    jnz .loop
    xor eax, eax
ret
    .found:
    mov rax, rdi
    ret

func lower ; void lower(char *str)
    lea rsi, [lower_table]
    .loop:
    movzx eax, byte [rdi]
    movzx eax, byte [rsi + rax]
    mov byte [rdi], al
    inc rdi
    movzx eax, byte [rdi]
    test eax, eax
    jnz .loop
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

    collect_stack qword [rsi]
    pop rbp
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

section .rodata
    align 256
    lower_table:
    %define table db
    %assign i 0
    %rep 255
    %if 'A' <= i && i <= 'Z'
    %xdefine table table %eval(i + 32),
    %else
    %xdefine table table i,
    %endif
    %assign i i+1
    %endrep
    table i
    %undef table
