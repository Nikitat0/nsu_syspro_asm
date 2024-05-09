default rel

%macro func 1
    section .text.%[%1] progbits alloc exec nowrite align=16 
    global %1
    %1:
%endmacro

%macro __string 1-*
    [section .rodata]
    %1 db %{2:-1}, 0
    __SECT__
%endmacro

%macro __assert_ctx 2-*
    %ifnctx %1
        %fatal %str(%{2:-1})
    %endif
%endmacro

%macro exit 0-1
    extern exit
    %if %0 == 0
    xor edi, edi
    %else
    mov rdi, %1
    %endif
    jmp exit wrt ..plt
%endmacro

%macro perror 1
    extern perror
    lea rdi, [rel %%error]
    call perror wrt ..plt
    exit -1
    __string %%error, %1
%endmacro

%macro error 1
    extern print_string
    lea rdi, [rel %%error]
    call print_string wrt ..plt
    exit -1
    __string %%error, %1
%endmacro

%macro collect_stack 1-2
    extern dalloc

    %if %0 == 2
    lea rdi, %2
    %else
    mov rdi, rbp
    %endif
    sub rdi, rsp
    jz %%skip
    mov %1, rdi
    shr %1, 3
    mov rax, rsp
    and rsp, -16
    push rax
    push %1
    call dalloc
    pop rcx
    pop rsp
    
    %%loop:
    pop qword [rax + 8 * rcx - 8]
    dec rcx
    jnz %%loop
    %%skip:
%endmacro
