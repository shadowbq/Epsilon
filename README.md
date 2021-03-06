# Epsilon
NERF'd - Do no harm.

Powershell examples of using common substitution, transformation, and encoding of data and files. 

To include: `bitwise-xor`, `base64`, `rot18`, and `aes` (aes-cbc-pkcs7).

> Don’t write your own solution. Cryptography is an extremely complex topic requiring mastery of mathematics and computer science. Use known good solutions from reputable parties.

## Not secure by any means

`coder.ps1`

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

![Diagram of Process](media/Diagram%20of%20coder.png)

I use the term `mirror` to mean it matches exactly the other file (`xord.txt == mirror-xord.txt`)

```ps1
 .\coder.ps1 xor .\quickbrownfox.txt .\xord.txt
 .\coder.ps1 encode .\xord.txt .\encode.txt
 .\coder.ps1 rot18 .\encode.txt .\rotated.txt
 
---

 .\coder.ps1 rot18 .\rotated.txt .\mirror-encoded.txt
 .\coder.ps1 decode .\mirror-encoded.txt .\mirror-xord.txt
 .\coder.ps1 xor .\mirror-xord.txt .\mirror-quickbrownfox.txt
```

## AES Encryption of Files 

![Diagram of AES](media/diagram%20of%20aes-cbc.png)

> Implemented with aes256 + random IV + CBC + PKSC7 

Works with bytes, so `.pe32` is fine

```ps1
aes.ps1 encrypt K7Y6VTFrz3nuglS6iFLm4PRp6Zh/JJKghMiLzyRl7AA= .\plain.txt .\cipher.aes
aes.ps1 decrypt K7Y6VTFrz3nuglS6iFLm4PRp6Zh/JJKghMiLzyRl7AA= .\cipher.aes .\plain.txt
```

AES is a block cipher with a block length of 128 bits. AES allows for three different key lengths: 128, 192, or 256 bits. The above example uses a base64 encoded 256 key length.

### Block Cipher Mode 

Mode of operations, like `CBC`, are defined to encrypt more data than the blocksize of the symmetric blockcipher.

 In CBC mode, each block of plaintext is XORed with the previous ciphertext block before being encrypted. This way, each ciphertext block depends on all plaintext blocks processed up to that point. To make each message unique, an initialization vector must be used in the first block.

Modern block ciphers like the Advanced Encryption Algorithm (AES) have larger block sizes than DES and Blowfish. If using AES with a 128-bit block, pad to the next multiple of 16. Note, that it is the block size that matters, not the size of the key.

* https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation

### Padding Modes

|PKCS7	| The PKCS #7 padding string consists of a sequence of bytes, each of which is equal to the total number of padding bytes added.|
|--|--|
|Data | 	FF FF FF FF FF FF FF FF FF FF|
|PKCS7 padding |	FF FF FF FF FF FF FF FF FF 06 06 06 06 06 06 06|

* https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.paddingmode?view=net-6.0
* https://en.wikipedia.org/wiki/Padding_(cryptography)

Note: [Cryptii.com](https://github.com/cryptii/cryptii/issues/95#issuecomment-794358273) uses CMS padding not PKCS7 in it's CBC implementation. 

### Alternative GCM 

When using symmetric encryption, you should be favoring authenticated encryption, such as AES-GCM (Galois/Counter Mode), rather than unauthenticated encryption, such as AES-CBC (Cipher Block Chaining). AES-CBC is not authenticated encryption, so it is vulnerable to the various chosen-ciphertext attacks. As of v1.3, TLS no longer supports AES-CBC. GCM includes an in-built integrity check.

If you are using .NET Core 3 onwards, the AES-GCM implementation found in `System.Security.Cryptography`. On Windows and Linux, this API will call into the OS implementations of AES, while macOS will require you to have OpenSSL installed. A future example will use AES-256-GCM.

## Reference

* [Cryptii.com](https://cryptii.com/) - Great visual UI in local javascript to validate processes.
