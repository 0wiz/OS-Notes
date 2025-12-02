param([string]$InputFile)

. "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

$dir  = [System.IO.Path]::GetDirectoryName($InputFile)
$base = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
$ext  = [System.IO.Path]::GetExtension($InputFile)
$OutputFile = Join-Path $dir ($base + "_compressed" + $ext)

ff265 -i $InputFile $OutputFile