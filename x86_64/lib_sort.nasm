func sort_strs ; void sort_strs(const char *strs[], size_t nstrs)
    test rsi, rsi
    jz .skip

    push rbx
    push rbp
    mov rbp, rsp

    xor eax, eax
    test sil, 1
    setz al
    shl eax, 3
    lea rax, [rax + 8 * rsi]
    sub rsp, rax

    mov r11, rsp
    xorps xmm0, xmm0
    xor edx, edx
    call sort_strs_impl

    leave
    pop rbx
    .skip:
ret

; This function is internal and does not follow calling convention
; void sort_strs_impl(const char *strs[], size_t nstrs, size_t pos)
; rbx: scratch
; r11: void *buf[]
; xmm0 = 0
sort_strs_impl:
    cmp rsi, 2
    jb .skip1

    push 0
    push r12
    push r13
    push rbp
    mov rbp, rsp

    push rdi
    push rsi
    push rdx
    inc qword [rsp]

    mov rax, 256 * 8 
    sub rsp, rax
    .loop_null_counters:
    movaps [rsp + rax - 16], xmm0
    sub rax, 16
    jnz .loop_null_counters
    ; [rsp]: uint64_t counters[]

    xor ecx, ecx
    .count_loop:
        mov rax, [rdi + 8 * rcx]
        mov [r11 + 8 * rcx], rax
        movzx ebx, byte [rax + rdx]
        inc qword [rsp + 8 * rbx]
        inc rcx
        cmp rcx, rsi
    jne .count_loop

    mov r9, [rsp]
    sub [rbp - 16], r9
    jz .skip2
    shl r9, 3
    add [rbp - 8], r9

    xor eax, eax
    xor ecx, ecx
    .loop_prefix_sums:
        add rax, [rsp + 8 * rcx]
        mov [rsp + 8 * rcx], rax
        inc ecx
        test cl, cl
    jnz .loop_prefix_sums

    mov rcx, rsi
    .loop_restore:
        mov rbx, [r11 + 8 * rcx - 8]
        movsx eax, byte [rbx + rdx]
        dec qword [rsp + 8 * rax]
        mov rax, [rsp + 8 * rax]
        mov [rdi + 8 * rax], rbx
    dec rcx
    jnz .loop_restore
    
    mov rdi, rsp
    push qword [rsp]
    mov ecx, 254
    .loop_examine_buckets:
    mov rax, [rdi + 8 * rcx]
    cmp rax, [rsp]
    je .no_push
    push rax
    .no_push:
    dec ecx
    jnz .loop_examine_buckets

    .loop:
    mov rdi, [rbp - 8]
    mov rdx, [rbp - 24]
    pop rax
    mov r12, [rsp]
    sub r12, rax
    
    mov r13, rsp
    and rsp, -16
    mov rsi, r12
    call sort_strs_impl
    mov rsp, r13

    lea rax, [8 * r12]
    add [rbp - 8], rax
    sub [rbp - 16], r12
    jnz .loop

    .skip2:
    add rsp, 256 * 8 + 24
    leave
    pop r13
    pop r12
    add rsp, 8
.skip1:
ret

extern print_int
extern print_char
extern print_string
extern print_newline
