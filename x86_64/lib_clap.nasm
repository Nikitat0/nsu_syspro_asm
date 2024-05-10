section .text

extern print_char
extern print_string
extern print_newline

func clap ; char **clap(char *argv[], size_t *npos_args, options_t *options)
    push rbp
    mov rbp, rsp
    lea r11, [options_table]

    mov r8, [rdx] ; r8: options_t options_mask
    and qword [rdx], 0

    .arg_loop:
    lea rdi, [rdi + 8]
    mov r9, [rdi]
    test r9, r9
    jz .arg_loop_end
    cmp byte [r9], '-'
    je .opt_loop
        push r9
        jmp .arg_loop

        .opt_loop:
        inc r9
        movzx r10, byte [r9]
        test r10, r10
        jz .arg_loop
        mov cl, [r11 + r10]
        cmp cl, 64
        je .unknown_option
        mov eax, 1
        shl rax, cl
        test r8, rax
        jz .unknown_option
        or qword [rdx], rax
        jmp .opt_loop
    .arg_loop_end:

    collect_stack qword [rsi]
    pop rbp
ret
    .unknown_option:
    and rsp, -16
    mov [rsp], r10
    lea rdi, [unknown_option_error]
    call print_string
    mov rdi, [rsp]
    call print_char
    call print_newline
    exit -1

section .rodata
    unknown_option_error:
        db "error: unknown option -", 0

    %push
    %define %$table
    %assign %$i 0
    %rep 127
    %xdefine %$table %$table option(%$i),
    %assign %$i %$i + 1
    %endrep
    options_table db %$table option(%$i)
    %pop
