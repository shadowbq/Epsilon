# Epsilon
NERF'd - Do no harm.

> Don’t write your own solution. Cryptography is an extremely complex topic requiring mastery of mathematics and computer science. Use known good solutions from reputable parties.

## Not secure by any means

`coder.ps1`

## Base64

Base64 any file including binary files

```ps1
coder "encode" "plainfile" "encodedfile"
coder "decode" "encodedfile" "plainfile"
```
* https://en.wikipedia.org/wiki/Base64

## ROT18

ROT13 is a shift cipher, that’s a simple kind of encryption where the ciphertext is created by taking the plain text message and shifting (moving forward in the alphabet) by a certain number of letters. The name is a shorthand version of ‘rotation 13’. It’s also a type of substitution cipher, because one letter is substituted for another.

ROT5 is the numeric equivalent of ROT13. The numbers 0-4 are written on the top row, and 5-9 on the bottom. This allows numbers to be encrypted in the same manner as ROT13, by using their inverse. Using ROT13 and ROT5 together is sometimes called ROT18.

```ps1
coder "rot18" "plaintextfile" "rotfile"
coder "rot18" "rotfile" "plaintextfile"
```

* https://en.wikipedia.org/wiki/ROT13

## XOR

Boolean logic operation that is widely used in cryptography as well as in generating parity bits for error checking and fault tolerance. XOR compares two input bits and generates one output bit. This example uses a hardcode single byte key. If the bits are the same, the result is 0. If the bits are different, the result is 1.

Note: In this example the xor_key is hardcoded at `0x0f`

```
plaintext = 0x3A (58)
binary: 0011 1010

xor_key = 0x0f (15)
binary: 0000 1111

cipher = 0x35 (53)
binary: 0011 0101
```

* https://en.wikipedia.org/wiki/Bitwise_operation#XOR_2
* https://en.wikipedia.org/wiki/XOR_cipher

## Combining 

Combining the two methods to rot18 a base64 binary for transmission.

Note: In this example `rot18` will only rotate 62 different values, not swapping `/` (111111) or the ending `=` (padding) base64 encoding.

```ps1
coder "encode" "plainfile" "encodedfile"
coder "rot18" "encodedfile" "rotated"
-- 
coder "rot18" "rotated" "encodedfile"
coder "decode" "encodedfile" "plainfile"
```

Combining the three methods.

```ps1
 .\coder.ps1 encode .\quick.txt .\encode.txt
 .\coder.ps1 rot18 .\encode.txt .\rotated.txt
 .\coder.ps1 xor .\rotated.txt .\xord.txt
---
 .\coder.ps1 xor .\xord.txt .\mirror-rotated.txt
 .\coder.ps1 rot18 .\mirror-rotated.txt .\mirror-encoded.txt
 .\coder.ps1 decode .\mirror-encoded.txt .\fox.txt
```

## AES Encryption of Files 

Works with bytes, so `.pe32` is fine

```ps1
aes.ps1 encrypt K7Y6VTFrz3nuglS6iFLm4PRp6Zh/JJKghMiLzyRl7AA= .\plain.txt .\cipher.aes
aes.ps1 decrypt K7Y6VTFrz3nuglS6iFLm4PRp6Zh/JJKghMiLzyRl7AA= .\cipher.aes .\plain.txt
```
