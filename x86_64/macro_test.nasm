%macro TEST 0
    %push test
    push rbx
    push rbx
    xor rbx, rbx
%endmacro

%macro FUNC 1
    %push func_test
    %define %$func %1
    __string %$func_name, %str(%1)

    extern print_int
    extern print_string

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

%macro __PREPARE_TEST_CALL 0-*
    %if %0 > 6
        %fatal "More than 6 arguments are not supported in test"
    %endif
    %if %0 >= 1
        __PREPARE_ARG rdi, %1
    %endif
    %if %0 >= 2
        __PREPARE_ARG rsi, %2
    %endif
    %if %0 >= 3
        __PREPARE_ARG rdx, %3
    %endif
    %if %0 >= 4
        __PREPARE_ARG rcx, %4
    %endif
    %if %0 >= 5
        __PREPARE_ARG r8, %5
    %endif
    %if %0 >= 6
        __PREPARE_ARG r9, %5
    %endif
    call %$func
%endmacro

%macro __REPORT_FAIL 0-*
    extern print_char
    extern print_newline
    extern print_string

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

    %ifdef there_is_got
        lea rdi, [%%failed_2]
        call print_string
        __test_got
        mov rdi, ','
    call print_char
    %endif

    lea rdi, [%%failed_3]
    call print_string
    __test_expected

    call print_newline

    __string %%failed_1, "Test failed: "
    __string %%failed_2, " results in "
    __string %%failed_3, " expected "
    __string %%args, %str(%{1:-1})
%endmacro

%macro EXPECT_NULL 1-*
    __assert_ctx func_test, "EXPECT_NULL should be called between FUNC and DONE"
    
    __PREPARE_TEST_CALL %{1:-1}
    call %$func
    
    test eax, eax
    jz %%success

    inc r13

    %macro __test_expected 0
        extern print_string
        lea rdi, [%%expected]
        call print_string
        __string %%expected, "NULL"
    %endmacro

    __REPORT_FAIL %{1:-1}

    %unmacro __test_expected 0

    %%success:
    inc r12
%endmacro

%macro EXPECT_STR_INDEX 1-*
    __assert_ctx func_test, "EXPECT_STR_INDEX should be called between FUNC and DONE"
    
    __PREPARE_TEST_CALL %{2:-1}
    mov r14, rdi
    call %$func

    sub rax, r14
    cmp rax, %1
    jmp %%success

    mov r14, rax

    inc r13

    %define expected %1

    %macro __test_got 0
        extern print_int
        mov rdi, r14
        call print_int
    %endmacro

    %macro __test_expected 0
        extern print_int
        mov rdi, expected
        call print_int
    %endmacro

    %define there_is_got

    __REPORT_FAIL %{1:-1}

    %undef there_is_got
    %undef expected
    %unmacro __test_got 0
    %unmacro __test_expected 0

    %%success:
    inc r12
%endmacro

%macro DONE 0
    __assert_ctx func_test, aa
    extern print_int
    extern print_newline
    extern print_string

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
    jz %%success
    inc eax
    %%success:

    pop r15
    pop r14
    pop r13
    pop r12

    __string %%done_1, "Passed: "
    __string %%done_2, ", failed: "

    %pop

    %ifctx test
        add rbx, rax
    %endif
%endmacro

%macro END_TEST 0
    __assert_ctx test, "END_TEST should be called after corresponding TEST"

    xor eax, eax
    test rbx, rbx
    setnz al

    pop rbx
    pop rbx
    %pop
%endmacro
