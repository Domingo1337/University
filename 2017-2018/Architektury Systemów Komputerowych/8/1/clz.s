       .global clz
        .type clz,@function

        .section .text

clz:
        mov %rdi, %rax
	shrq $1, %rax
	orq %rax, %rdi
	
	mov %rdi, %rax
	shrq $2, %rax
	orq %rax, %rdi
	
	mov %rdi, %rax
	shrq $4, %rax
	orq %rax, %rdi
		
	mov %rdi, %rax
	shrq $8, %rax
	orq %rax, %rdi

	mov %rdi, %rax
	shrq $16, %rax
	orq %rax, %rdi
	
	mov %rdi, %rax
	shrq $32, %rax
	orq %rax, %rdi
	
	mov %rdi, %rax
	shrq $64, %rax
	orq %rax, %rdi

	not %rdi
	popcnt %rdi, %rax
	ret

        .size   clz, . - clz
