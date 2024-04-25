section .text
extern printf

global print_int ; void print_int(int n)
print_int:
    mov rsi, rdi
    lea rdi, [print_int_fmt]
    xor eax, eax
    jmp printf wrt ..plt

global print_string ; void print_string(const char *str)
print_string:
    mov rsi, rdi
    lea rdi, [print_string_fmt]
    xor eax, eax
    jmp printf wrt ..plt

global print_char ; void print_char(char c)
print_char:
    mov rsi, rdi
    lea rdi, [print_char_fmt]
    xor eax, eax
    jmp printf wrt ..plt

global print_newline ; void print_newline()
print_newline:
    mov edi, 10
    jmp print_char

section .rodata
print_int_fmt:
    db "%lld", 0
print_string_fmt:
    db "%s", 0
print_char_fmt:
    db "%c", 0
atoi_on_empty:
    db "atoi: empty", 0
