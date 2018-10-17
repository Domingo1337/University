       .global clz
        .type clz, @function

        .section .text

clz:
	mov $0, %rax
	test %rdi, %rdi
	jne L0
	mov $64, %rax
	ret	

L0:	movq $0xffffffff, %rsi
	cmpq %rsi, %rdi
	jae L1
	addq $32, %rax
	shlq $32, %rdi

L1:	movq $0xffffffffffff, %rsi
	cmpq %rsi, %rdi
	jae L2
	addq $16, %rax
	shlq $16, %rdi

L2:	movq $0xffffffffffffff, %rsi
	cmpq %rsi, %rdi
	jae L3
	addq $8, %rax
	shlq $8, %rdi

L3:	movq $0xfffffffffffffff, %rsi
	cmpq %rsi, %rdi
	jae L4
	addq $4, %rax
	shlq $4, %rdi

L4:	movq $0x3fffffffffffffff, %rsi
	cmpq %rsi, %rdi
	jae L5
	addq $2, %rax
	shlq $2, %rdi

L5:	movq $0x7fffffffffffffff, %rsi
	cmpq %rsi, %rdi
	jae L6
	addq $1, %rax
	shlq $1, %rdi

L6:	ret

        .size   clz, . - clz
