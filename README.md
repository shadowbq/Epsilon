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
coder "rot" "plaintextfile" "rotfile"
coder "rot" "rotfile" "plaintextfile"
```


Combining the two methods to rot13 a base64 binary for transmission.

```ps1
coder "encode" "plainfile" "encodedfile"
coder "rot" "encodedfile" "rotated"
-- 
coder "rot" "rotated" "encodedfile"
coder "decode" "encodedfile" "plainfile"
```
