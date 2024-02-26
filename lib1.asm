.macro syscall %n
	li a7, %n
	ecall
.end_macro

.macro readch
	syscall 12
.end_macro

.macro printch
	syscall 11
.end_macro

.macro exit
	syscall 93
.end_macro
