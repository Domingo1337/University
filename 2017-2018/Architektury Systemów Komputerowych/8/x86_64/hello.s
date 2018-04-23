        .global _start

write = 1
exit  = 60

        .section .text
_start:
        # write(int fd, const void *buf, size_t count)
        mov     $write,%rax
        mov     $1,%rdi
        mov     $msg,%rsi
        mov     $msg_len,%rdx
        syscall

# exit(int status)
        mov     $exit,%rax
        mov     $1,%rdi
        syscall

        .section .rodata
msg:
        .ascii "hello, world!\n"
        .equ    msg_len, . - msg

# vim: ft=gas ts=8 sw=8 et
