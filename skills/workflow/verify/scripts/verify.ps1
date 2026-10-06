param([string]$Path = '.', [switch]$NoBuild, [switch]$NoTest)
# Auto-detect project type and run build / test / lint / typecheck, then show git diff stat.
# Prints one line per step: PASS / FAIL / SKIP. Exit code = number of FAIL.
$ErrorActionPreference = 'Continue'
Set-Location $Path
$fails = 0
function Step($name, [scriptblock]$cmd) {
  Write-Host "=== $name"
  $out = & $cmd 2>&1
  $code = $LASTEXITCODE
  $out | Select-Object -Last 25 | ForEach-Object { "  $_" }
  if ($code -eq 0 -or $null -eq $code) { "RESULT $name PASS" } else { "RESULT $name FAIL (exit $code)"; $script:fails++ }
}
function Has($cmd) { [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
$ran = $false

if (Test-Path 'package.json') {
  $pkg = Get-Content package.json -Raw | ConvertFrom-Json
  $pm = if (Test-Path 'pnpm-lock.yaml') { 'pnpm' } elseif (Test-Path 'yarn.lock') { 'yarn' } else { 'npm' }
  foreach ($s in 'build', 'lint', 'typecheck', 'test') {
    if ($pkg.scripts.$s -and -not (($s -eq 'build' -and $NoBuild) -or ($s -eq 'test' -and $NoTest))) { Step "node:$s" { & $pm run $s }; $ran = $true }
  }
  if (-not $pkg.scripts.typecheck -and (Test-Path 'tsconfig.json')) { Step 'node:tsc' { npx --no-install tsc --noEmit }; $ran = $true }
}
if ((Test-Path 'pyproject.toml') -or (Test-Path 'setup.py') -or (Test-Path 'requirements.txt')) {
  if (Has 'ruff') { Step 'py:ruff' { ruff check . }; $ran = $true }
  if (Has 'mypy' -and (Select-String -Path pyproject.toml -Pattern 'mypy' -Quiet -ErrorAction SilentlyContinue)) { Step 'py:mypy' { mypy . }; $ran = $true }
  if (-not $NoTest -and ((Test-Path 'tests') -or (Test-Path 'test'))) { Step 'py:pytest' { python -m pytest -q }; $ran = $true }
}
if (Test-Path 'CMakeLists.txt') {
  if (-not $NoBuild) {
    Step 'cmake:configure' { cmake -S . -B build }
    Step 'cmake:build' { cmake --build build --config Debug }
  }
  if (-not $NoTest) { Step 'cmake:ctest' { ctest --test-dir build -C Debug --output-on-failure } }
  $ran = $true
} elseif ((Get-ChildItem -Filter *.sln -File | Select-Object -First 1) -and -not $NoBuild) {
  $sln = (Get-ChildItem -Filter *.sln -File | Select-Object -First 1).Name
  if (Has 'dotnet') { Step 'dotnet:build' { dotnet build $sln -nologo -v q } }
  if (-not $NoTest -and (Has 'dotnet')) { Step 'dotnet:test' { dotnet test $sln -nologo -v q } }
  $ran = $true
}
if ((Test-Path 'Cargo.toml') -and (Has 'cargo')) {
  if (-not $NoBuild) { Step 'cargo:build' { cargo build -q } }
  if (-not $NoTest) { Step 'cargo:test' { cargo test -q } }
  $ran = $true
}
if (-not $ran) { 'RESULT build/test SKIP (no known project file in this directory)' }

if (Has 'git') {
  git rev-parse --is-inside-work-tree 2>$null | Out-Null
  if ($LASTEXITCODE -eq 0) {
    '=== git diff'
    git status -sb | Select-Object -First 30
    git diff HEAD --stat | Select-Object -Last 15
    $secret = git diff HEAD | Select-String -Pattern '(?i)(api[_-]?key|secret|password|token)\s*[:=]\s*["'']?[A-Za-z0-9_\-]{16,}'
    if ($secret) { 'RESULT secret-scan FAIL (possible secret in diff)'; $fails++ } else { 'RESULT secret-scan PASS' }
  }
}
"SUMMARY: $fails FAIL"
exit $fails
