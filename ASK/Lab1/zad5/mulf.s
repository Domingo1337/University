       .global mulf
        .type mulf,@function

        .section .text

mulf:
	
        M1 = %r8
	E1 = %r9
	mov %rdi, M1
	andq $0x7fffff, M1
	orq  $0x800000, M1
	mov %rdi, E1
	shrq $23, E1
	andq $0xff, E1
	
	M2 = %r10
	E2 = %r11
	mov %rsi, M2
	andq $0x7fffff, M2
	orq  $0x800000, M2
	mov %rsi, E2
	shrq $23, E2
	andq $0xff, E2	

	mov M1, %rax
	mulq M2
	#mov %rax, %rdx
	#andq $0x800000, %rdx
	#mov %rax, %rcx
	#andq $0x1000000, %rcx
	#test %rcx, %rcx
	#je L2
	#addq %rdx, %rax
L1:	shrq $23, %rax
	
	mov %rax, M1
	andq $0x800000, %rax
	test %rax, %rax
	jne L2
	addq $1, E2
	shrq $1, M1
	
L2:	andq $0x7fffff, M1
	addq E1, E2
	subq $127, E2
	mov E2, %rax
	shlq $23, E2	
	
	mov $1, %rdx
	shlq $31, %rdx
	xorq %rdi, %rsi
	andq %rdx, %rsi
	mov %rsi, %rax	

	orq E2, %rax
	addq M1, %rax	
	ret

        .size   mulf, . - mulf
