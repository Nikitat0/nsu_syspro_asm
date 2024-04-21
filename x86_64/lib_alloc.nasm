default rel

section .text
extern malloc

global dalloc
dalloc:
    call malloc wrt ..plt
    test rax, rax
    jz .err
    ret 
    .err perror "dalloc"
