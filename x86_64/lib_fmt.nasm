default rel

section .text
extern printf

global print_int
print_int:
    mov rsi, rdi
    lea rdi, [print_int_fmt]
    xor eax, eax
    jmp printf wrt ..plt

global print_string
print_string:
    mov rsi, rdi
    lea rdi, [print_string_fmt]
    xor eax, eax
    jmp printf wrt ..plt

global print_char
print_char:
    mov rsi, rdi
    lea rdi, [print_char_fmt]
    xor eax, eax
    jmp printf wrt ..plt

global print_newline
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
