       .global lcm_gcd
        .type lcm_gcd,@function

        .section .text

lcm_gcd:
	movq %rdi, %rax
	movq %rsi, %rcx

L1:	
	xorq %rdx, %rdx
	divq %rcx		#rdx = rbx%rax  #rax = rbx/rax
	test %rdx, %rdx
	jz L2 
	
	movq %rcx, %rax
	movq %rdx, %rcx
	jmp L1
L2:
				#rcx = gcd
				#rdi = x
				#rsi = y
	movq %rdi, %rax 	#rax = x
 	mulq %rsi		#rax = x*y
	divq %rcx 		#rax = x*y/gcd(x,y)
	movq %rcx, %rdx	

	ret
	
        .size   lcm_gcd, . - lcm_gcd

