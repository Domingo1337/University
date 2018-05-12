       .global insert_sort
        .type insert_sort,@function

        .section .text

insert_sort:

	first = %rdi
	last = %rsi

	sorted = %r8
	temp = %r9
	current = %r10

	movq first, sorted
	
L1:	cmpq last, sorted
	je L2

	movq 8(sorted), current
	leaq 8(sorted), temp

L3:	cmpq -8(temp), current
	jge L4
	cmpq first, temp
	jle L4
	
	mov -8(temp), %r11
	mov %r11, (temp)	

	subq $8, temp
	jmp L3	
		
L4:	movq current, (temp)
	addq $8, sorted
	jmp L1
		
L2:	ret

        .size   insert_sort, . - insert_sort
