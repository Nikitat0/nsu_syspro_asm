extern malloc

func dalloc ; void *dalloc(size_t size)
    call malloc wrt ..plt
    test rax, rax
    jz .err
ret 
    .err perror "dalloc"
