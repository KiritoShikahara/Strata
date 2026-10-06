param([Parameter(Mandatory = $true)][string]$Name)
# Locate a command-line tool on Windows: PATH, common install dirs, then winget catalog.
$ErrorActionPreference = 'SilentlyContinue'
$found = @()
$cmd = Get-Command $Name -All
if ($cmd) { $found += $cmd | ForEach-Object { "PATH: $($_.Source)" } }
$roots = @($env:ProgramFiles, ${env:ProgramFiles(x86)}, "$env:LOCALAPPDATA\Programs", "$env:LOCALAPPDATA\Microsoft\WinGet\Packages",
  "$env:USERPROFILE\scoop\apps", "$env:ChocolateyInstall\bin", "$env:USERPROFILE\.cargo\bin", "$env:APPDATA\npm",
  "$env:LOCALAPPDATA\hermes\node") | Where-Object { $_ -and (Test-Path $_) }
foreach ($r in $roots) {
  Get-ChildItem -Path $r -Recurse -Depth 4 -File -Include "$Name.exe", "$Name.cmd", "$Name.bat", "$Name.ps1" |
    Select-Object -First 5 | ForEach-Object { $found += "DISK: $($_.FullName)" }
}
if ($found.Count -gt 0) { "FOUND"; $found | Select-Object -Unique; exit 0 }
"NOT FOUND: $Name"
if (Get-Command winget) {
  "winget candidates:"
  winget search --accept-source-agreements $Name 2>$null | Select-Object -First 8
}
if (Get-Command wsl) { $w = wsl -e sh -c "command -v $Name" 2>$null; if ($w) { "WSL: $w" } }
exit 1
