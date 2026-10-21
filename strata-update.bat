@echo off
rem Update Strata to the newest version, engine included (NVIDIA cards).
rem   strata-update.bat              update %STRATA_DIR% (else C:\Strata)
rem   strata-update.bat "D:\Strata"  update that folder
rem 1. runs Strata's own UPDATE.bat (newest code, moves an old-history clone to the new history)
rem 2. Strata 0.2.x source installs cannot fetch the engine themselves (#3437 #3456): this downloads the newest
rem    strata-engine-*-windows-x86_64-cuda-cuda13 (or cuda12 for drivers older than 580) from the official release,
rem    checks its SHA-256 against SHA256SUMS.txt and unpacks it over engine\ (the old one is kept in engine\.backup-<version>).
setlocal
title Strata update
set "SD=%~1"
if not defined SD set "SD=%STRATA_DIR%"
if not defined SD set "SD=C:\Strata"
if not exist "%SD%\UPDATE.bat" (
  echo Strata not found at %SD%. Run install-strata-qwen.bat first, or pass the Strata folder.
  pause
  exit /b 1
)

echo [1/2] Updating Strata in %SD% ...
call "%SD%\UPDATE.bat" < nul
cd /d "%~dp0"

echo.
echo [2/2] Checking the engine ...
set "STRATA_SD=%SD%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((Get-Content -LiteralPath '%~f0' -Raw) -split '#PS-BEGIN#')[2]"
set "RC=%errorlevel%"
if "%RC%"=="0" (
  echo.
  echo Done. Start the model with strata-qwen.bat / strata-hermes.bat as before.
) else (
  echo.
  echo The engine was not updated ^(the reason is above^). Strata still starts with the engine it had.
)
pause
exit /b %RC%

#PS-BEGIN#
$ErrorActionPreference = 'Stop'
$sd = $env:STRATA_SD
$eng = Join-Path $sd 'engine'
try {
  $drv = (& nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>$null | Select-Object -First 1)
} catch { $drv = $null }
if (-not $drv) {
  Write-Host '  No NVIDIA card found (nvidia-smi). AMD / Intel engines are not handled here: see docs\AMD_HIP.md.'
  exit 1
}
$cuda = if ([version]($drv.Trim() + '.0') -ge [version]'580.65.0') { 'cuda13' } else { 'cuda12' }
Write-Host "  NVIDIA driver $($drv.Trim()): $cuda engine"

$rel = Invoke-RestMethod -Uri 'https://api.github.com/repos/Niko1221/Strata/releases/latest' -Headers @{ 'User-Agent' = 'strata-update' }
$pat = '^strata-engine-([0-9.]+)-windows-x86_64-cuda-' + $cuda + '\.tar\.gz$'
$asset = $rel.assets | Where-Object { $_.name -match $pat } |
  Sort-Object { [version]([regex]::Match($_.name, $pat).Groups[1].Value) } | Select-Object -Last 1
if (-not $asset) { Write-Host "  The latest release ($($rel.tag_name)) has no Windows $cuda engine."; exit 1 }
$new = [regex]::Match($asset.name, $pat).Groups[1].Value

$have = '0'
$bj = Join-Path $eng 'BUILD.json'
if (Test-Path $bj) { $have = [string](Get-Content $bj -Raw | ConvertFrom-Json).version }
if ([version]$have -ge [version]$new) { Write-Host "  [ok] engine $have is already the newest ($new)"; exit 0 }
Write-Host "  Engine $have -> $new ($($asset.name), $([math]::Round($asset.size / 1MB)) MB)"

$tmp = Join-Path $env:TEMP 'strata-engine-update'
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$tgz = Join-Path $tmp $asset.name
$sums = $rel.assets | Where-Object { $_.name -eq 'SHA256SUMS.txt' }
if (-not $sums) { Write-Host '  The release has no SHA256SUMS.txt: not installing an unchecked engine.'; exit 1 }
$want = ((& curl.exe -sL --fail $sums.browser_download_url) |
  Where-Object { $_ -match [regex]::Escape($asset.name) } | Select-Object -First 1) -replace '\s.*$', ''
if (-not $want) { Write-Host "  SHA256SUMS.txt does not list $($asset.name)."; exit 1 }

$ok = (Test-Path $tgz) -and ((Get-FileHash $tgz -Algorithm SHA256).Hash -ieq $want)
if (-not $ok) {
  Write-Host '  Downloading ...'
  & curl.exe -L --fail --retry 3 -o $tgz $asset.browser_download_url
  if ($LASTEXITCODE -ne 0) { Write-Host '  Download failed.'; exit 1 }
  if ((Get-FileHash $tgz -Algorithm SHA256).Hash -ine $want) {
    Remove-Item $tgz -Force
    Write-Host '  SHA-256 does not match the release: the file was deleted, nothing was installed.'
    exit 1
  }
}
Write-Host "  [ok] SHA-256 verified ($($want.Substring(0, 12))...)"

$x = Join-Path $tmp 'x'
Remove-Item $x -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $x | Out-Null
& "$env:SystemRoot\System32\tar.exe" -xzf $tgz -C $x
if ($LASTEXITCODE -ne 0 -or -not (Test-Path (Join-Path $x 'strata.exe'))) { Write-Host '  Unpacking failed.'; exit 1 }

if (Get-Process strata -ErrorAction SilentlyContinue) {
  Write-Host '  Strata is running: close its window, then run this file again (nothing is downloaded twice).'
  exit 1
}
New-Item -ItemType Directory -Force -Path $eng | Out-Null
if (Test-Path (Join-Path $eng 'strata.exe')) {
  $bk = Join-Path $eng ('.backup-' + $have)
  New-Item -ItemType Directory -Force -Path $bk | Out-Null
  Get-ChildItem $eng -File | Copy-Item -Destination $bk -Force
  Write-Host "  [ok] the old engine ($have) is kept in $bk"
}
Copy-Item (Join-Path $x '*') $eng -Recurse -Force
$ver = (& (Join-Path $eng 'strata.exe') --version 2>&1 | Select-Object -First 1)
Write-Host "  [ok] installed: $ver"
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
exit 0
