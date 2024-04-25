section .text

global atou ; uint64_t atou(const char *)
atou:
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
    .on_empty error "atoi: Empty"
    .on_unexpected error "atoi: Unexpected character"
    .on_overflow error "atoi: Overflow"

global strchr ; char* strchr(char* str, char ch)
strchr:
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
