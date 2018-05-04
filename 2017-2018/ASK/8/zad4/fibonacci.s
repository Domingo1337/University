       .global fibonacci
        .type fibonacci,@function

        .section .text

fibonacci:
        cmpq $1, %rdi
	ja L
	movq %rdi, %rax
	ret

L:	subq $1, %rdi
	push %rdi
	call fibonacci 	
	pop %rdi	
	push %rax
	
	subq $1, %rdi
	call fibonacci
	
	pop %rdx
	addq %rdx, %rax
	ret

        .size   fibonacci, . - fibonacci
