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
    %%error db %1, 0
%endmacro
