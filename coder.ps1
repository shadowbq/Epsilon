param (
    [Parameter(Mandatory=$true)]
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
} 

if ($method -eq "decode"){
	$infile_b64contents = Get-Content $infile -ReadCount 0
	$infile_contents_bytes = [System.Convert]::FromBase64String($infile_b64contents)
	$outfile_contents = $enc.GetString($infile_contents_bytes)
}

if ($method -eq "rot") {
	$infile_b64contents = Get-Content $infile -ReadCount 0
	$infile_b64contents.ToCharArray() | ForEach-Object {
		if((([int] $_ -ge 97) -and ([int] $_ -le 109)) -or (([int] $_ -ge 65) -and ([int] $_ -le 77)))
		{
			$string += [char] ([int] $_ + 13);
		}
		elseif((([int] $_ -ge 110) -and ([int] $_ -le 122)) -or (([int] $_ -ge 78) -and ([int] $_ -le 90)))
		{
			$string += [char] ([int] $_ - 13);
		}
		else
		{
			$string += $_
		}        
	}
	$outfile_contents = $string
}

$outfile_contents | set-content -Path "$outfile"



