Param
(
	[Parameter(Mandatory = $true)]
	[ValidateSet('encrypt', 'decrypt')]
	[String] $method,

	[Parameter(Mandatory = $true)]
	[String] $key,

	[Parameter(Mandatory = $true)]
	[String] $infile, #Infile file
	[Parameter(Mandatory=$true)]
  [String] $outfile #Output File
)

$shaManaged = New-Object System.Security.Cryptography.SHA256Managed
$aesManaged = New-Object System.Security.Cryptography.AesManaged
$aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
$aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
$aesManaged.BlockSize = 128
$aesManaged.KeySize = 256

$aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($key))

switch ($method) {
	'encrypt' {
		$plainBytes = Get-Content $infile -Encoding Byte -ReadCount 0
		$encryptor = $aesManaged.CreateEncryptor()
		$encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
		$encryptedBytes = $aesManaged.IV + $encryptedBytes
		$aesManaged.Dispose()
		Set-Content -NoNewline  -Path $outfile -Value $encryptedBytes -Encoding Byte
		(Get-Item $outfile).LastWriteTime = (Get-Item $infile).LastWriteTime
		#return "File encrypted to $outfile"
	}

	'decrypt' {
		$cipherBytes = Get-Content $infile -Encoding Byte -ReadCount 0
		$aesManaged.IV = $cipherBytes[0..15]
		$decryptor = $aesManaged.CreateDecryptor()
		$decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
		$aesManaged.Dispose()
		Set-Content -NoNewline  -Path $outfile -Value $decryptedBytes -Encoding Byte
		(Get-Item $outfile).LastWriteTime = (Get-Item $infile).LastWriteTime
		#return "File decrypted to $outfile"
	}
}	
