%push
%assign %$i 0
%rep 128
    %if 'a' <= %$i && %$i <= 'z'
    %assign %[option %+ %eval(%$i)] %$i - 'a'
    %elif 'A' <= %$i && %$i <= 'Z'
    %assign %[option %+ %eval(%$i)] %$i - 'A' + 26
    %else
    %assign %[option %+ %eval(%$i)] 64
    %endif
%assign %$i %$i + 1
%endrep
%pop

%define option(opt) option %+ %eval(opt)

%macro doptions 0-*
    %push

    %assign %$value 0
    %rep %0
    
    %if option(%1) == 64
        %fatal %1 is not allowed value for option
    %endif
    %assign %$value %$value | (1 << option(%1))

    %rotate 1
    %endrep

    dq %$value
    %pop
%endmacro

%macro testopt 2
    test %1, 1 << option(%2)
%endmacro
