        .global sum
        .type sum,@function

        .section .text

sum:
        mov     %rdi, %rax
        add     %rsi, %rax
        ret

        .size   sum, . - sum

# vim: ts=8 sw=8 et
