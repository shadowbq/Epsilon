# Epsilon
NERF'd - Do no harm.

`coder.ps1`

## Not secure by any means

Base64 any file including binary files

```ps1
coder "encode" "plainfile" "encodedfile"
coder "decode" "encodedfile" "plainfile"
```

Extremely simple implementation of rotation13 on ALAPH/alpha only

```ps1
coder "rot18" "plaintextfile" "rotfile"
coder "rot18" "rotfile" "plaintextfile"
```


Combining the two methods to rot13 a base64 binary for transmission.

```ps1
coder "encode" "plainfile" "encodedfile"
coder "rot18" "encodedfile" "rotated"
-- 
coder "rot18" "rotated" "encodedfile"
coder "decode" "encodedfile" "plainfile"
```

Combining the three methods

```ps1
 .\coder.ps1 encode .\quick.txt .\encode.txt
 .\coder.ps1 rot18 .\encode.txt .\rotated.txt
 .\coder.ps1 xor .\rotated.txt .\xord.txt
---
 .\coder.ps1 xor .\xord.txt .\mirror-rotated.txt
 .\coder.ps1 rot18 .\mirror-rotated.txt .\mirror-encoded.txt
 .\coder.ps1 decode .\mirror-encoded.txt .\fox.txt
```
