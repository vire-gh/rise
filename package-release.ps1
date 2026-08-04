# Builds the files to upload as GitHub Release assets.
# Zips each folder's CONTENTS at the archive root, which is what the launcher's
# "unzip -> extract into path" step expects.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = $PSScriptRoot
$out  = Join-Path $root 'release'
New-Item -ItemType Directory -Force $out | Out-Null

foreach ($name in @('java', 'assets', 'natives', 'data')) {
    $src = Join-Path $root $name
    if (-not (Test-Path $src)) { Write-Host "skip  $name (missing)"; continue }
    $zip = Join-Path $out "$name.zip"
    if (Test-Path $zip) { Remove-Item $zip -Force }
    Write-Host "zip   $name ..."
    [System.IO.Compression.ZipFile]::CreateFromDirectory($src, $zip, 'Optimal', $false)
}

$jar = Join-Path $root 'Demise.jar'
if (Test-Path $jar) {
    Write-Host "copy  Demise.jar ..."
    Copy-Item $jar $out -Force
}

Write-Host ""
Write-Host "Upload these as release assets:"
Get-ChildItem $out | ForEach-Object { "{0,10:N1} MB  {1}" -f ($_.Length / 1MB), $_.Name }
Write-Host ""
Write-Host "Then edit manifest.txt so each url points at the release, and commit:"
Write-Host "  RiseLauncher.jar  Rise.bat  manifest.txt  logo.png  background.jpg  launcher-src/"
