       .global lcm_gcd
        .type lcm_gcd,@function

        .section .text

lcm_gcd:
	movq %rdi, %r8
.L1:	test %rsi, %rsi
	jz L2 

.L2:
	#rsi = 0 #rdi = gcd

	mov $41, %rdx
	mov $42, %rax
	ret

        .size   lcm_gcd, . - lcm_gcd

