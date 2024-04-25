section .text
extern malloc

global dalloc ; void *dalloc(size_t size)
dalloc:
    call malloc wrt ..plt
    test rax, rax
    jz .err
    ret 
    .err perror "dalloc"
