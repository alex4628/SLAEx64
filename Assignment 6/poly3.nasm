global _start			

section .text
_start:

    ;mov edx, 0x4321fedc
    push DWORD 0x4321fedc   ; push the value 0x4321fedc onto the stack
    pop rdx                 ; pop this value into RDX
    
    mov esi, 0x28121969
    
    clc                     ; add an instruction that makes no sense and clears the carry flag
    
    ;mov edi, 0xfee1dead
    mov r12d, 0xfee1dead    ; move the value 0xfee1dead into r12d
    xchg edi, r12d          ; exchange this value with EDI
    
    
    ;mov al, 0xa9
    xor rax, rax            ; zero out RAX
    add al, 169             ; add 0xa9 to AL
     
    syscall