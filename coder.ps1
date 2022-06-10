param (
    [Parameter(Mandatory=$true)]
    [ValidateSet('encode','decode','xor','rot18')][string]
    [string] $method, #method
    [Parameter(Mandatory=$true)]
    [string] $infile, #Infile file
    [Parameter(Mandatory=$true)]
    [string] $outfile #Output File
)

$enc = [System.Text.Encoding]::UTF8

if ($method -eq "encode") {
	$infile_contents =  Get-Content $infile -Encoding Byte -ReadCount 0
	$outfile_contents = [System.Convert]::ToBase64String($infile_contents)
	Set-Content -NoNewline -Path $outfile -Value $outfile_contents
} 
ElseIf ($method -eq "decode"){
	$infile_b64contents = Get-Content $infile -ReadCount 0 -Encoding UTF8
	$outfile_contents = [System.Convert]::FromBase64String($infile_b64contents)
	Set-Content -NoNewline  -Path $outfile -Value $outfile_contents -Encoding Byte
}
ElseIf ($method -eq "xor"){
	$xor_operand = [char]0x0f
	$infile_contents =  Get-Content $infile -Encoding Byte -ReadCount 0
	$length = $infile_contents.Count
	$xord_byte_array = New-Object Byte[] $length
	for($i=0; $i -lt $length ; $i++)
	{
	    $xord_byte_array[$i] = $infile_contents[$i] -bxor $xor_operand
	}
    Set-Content -NoNewline -Path $outfile -Value $xord_byte_array -Encoding Byte
}
ElseIf ($method -eq "rot18") {
	$n = 13
	$m = 5
	$infile_b64contents = Get-Content $infile -ReadCount 0 -Encoding UTF8
	$infile_b64contents.ToCharArray() | ForEach-Object {
		# a-m A-M
		if((([int] $_ -ge 97) -and ([int] $_ -le 109)) -or (([int] $_ -ge 65) -and ([int] $_ -le 77)))
		{
			$string += [char] ([int] $_ + $n);
		}
		# n-z N-Z
		elseif((([int] $_ -ge 110) -and ([int] $_ -le 122)) -or (([int] $_ -ge 78) -and ([int] $_ -le 90)))
		{
			$string += [char] ([int] $_ - $n);
		}
		elseif(([int] $_ -ge 48) -and ([int] $_ -le 52))
		{
			$string += [char] ([int] $_ + $m);
		}
		elseif(([int] $_ -ge 53) -and ([int] $_ -le 57))
		{
			$string += [char] ([int] $_ - $m);
		}
		else
		{
			$string += $_
		}        
	}
	$outfile_contents = $string
	Set-Content -NoNewline -Path $outfile -Value $outfile_contents
}
