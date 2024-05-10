; Begin test set
%macro TEST 0
    extern print_char
    extern print_int
    extern print_newline
    extern print_string

    %push test_set
    push rbx
    push rbx
    xor rbx, rbx
%endmacro

; Begin function test
%macro FUNC 1
    extern print_char
    extern print_int
    extern print_newline
    extern print_string

    %push func_test
    %define %$func %1
    __string %$func_name, %str(%1)

    mov rax, rsp
    and rsp, -16
    push rax
    push rbx
    push r12
    push r13
    push r14
    push r15
    xor r12, r12
    xor r13, r13
    ; r12: size_t totalc
    ; r13: size_t failedc
    ; r14: scratch
    ; r15: scratch

    lea rdi, [%%testing_1]
    call print_string
    lea rdi, [%$func_name]
    call print_string
    lea rdi, [%%testing_2]
    call print_string

    __string %%testing_1, "Testing function "
    __string %%testing_2, "...", 10
%endmacro

%macro EXPECT_NULL 1-*
    __assert_ctx func_test, "EXPECT_NULL should be called between FUNC and DONE"

    __PREPARE_ARGS %{1:-1}
    call %$func

    test rax, rax
    jz %%success

    inc r13
    mov r14, rax
    __REPORT_FAIL "int", "null", %{1:-1}

    %%success:
    inc r12
%endmacro

%macro EXPECT_STR_INDEX 2-*
    __assert_ctx func_test, "EXPECT_STR_INDEX should be called between FUNC and DONE"

    __PREPARE_ARGS %{2:-1}
    mov r14, rdi
    call %$func

    sub rax, r14
    cmp rax, %1
    je %%success

    inc r13
    mov r14, rax
    mov r15, %1
    __REPORT_FAIL "int", "int", %{2:-1}

    %%success:
    inc r12
%endmacro

; End test. Result is returned in rax; 0: success; 1: failed
%macro DONE 0
    __assert_ctx func_test, aa

    sub r12, r13

    lea rdi, [%%done_1]
    call print_string
    mov rdi, r12
    call print_int
    lea rdi, [%%done_2]
    call print_string
    mov rdi, r13
    call print_int
    call print_newline

    xor eax, eax
    test r13, r13
    setnz al

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rsp

    __string %%done_1, "Passed: "
    __string %%done_2, ", failed: "

    %pop

    %ifctx test_set
        add rbx, rax
    %endif
%endmacro

; End test set. Result is returned in rax; 0: success; 1: failed
%macro END_TEST 0
    __assert_ctx test_set, "END_TEST should be called after corresponding TEST"

    xor eax, eax
    test rbx, rbx
    setnz al

    pop rbx
    pop rbx
    %pop
%endmacro

%macro __PREPARE_ARG 2
    %ifstr %2
        __string %%arg, %2
        lea %1, [%%arg]
    %elifid %2
        lea %1, [%2]
    %else
        mov %1, %2
    %endif
%endmacro

%macro __PREPARE_ARGS_IMPL 6-12
    %rep %0 - 6
    __PREPARE_ARG %1, %7
    %rotate 1
    %endrep
%endmacro

%macro __PREPARE_ARGS 0-6
    %if %0 != 0
    __PREPARE_ARGS_IMPL rdi, rsi, rdx, rcx, r8, r9, %{1:-1}
    %endif
%endmacro

%macro __REPORT_FAIL 2-*
    lea rdi, [%%failed_1]
    call print_string
    lea rdi, [%$func_name]
    call print_string
    mov rdi, '('
    call print_char
    lea rdi, [%%args]
    call print_string
    mov rdi, ')'
    call print_char

    lea rdi, [%%failed_2]
    call print_string
    __TYPED_PRINT %1, r14
    mov rdi, ','
    call print_char

    lea rdi, [%%failed_3]
    call print_string
    __TYPED_PRINT %2, r15

    call print_newline

    __string %%failed_1, "Test failed: "
    __string %%failed_2, " results in "
    __string %%failed_3, " expected "
    __string %%args, %str(%{3:-1})
%endmacro

%macro __TYPED_PRINT 2
    %if %1 == "int"
        mov rdi, %2
        call print_int
    %elif %1 == "str"
        mov rdi, %2
        call print_string
    %elif %1 == "null"
        lea rdi, [%%null]
        call print_string
    %else
        %fatal Unknown fmt: %1
    %endif
    __string %%null, "NULL"
%endmacro
