param([switch]$Json, [string]$StrataDir = $(if ($env:STRATA_DIR) { $env:STRATA_DIR } else { 'D:\Strata' }))
# KiriDev environment diagnosis. Prints OK/WARN/FAIL per item. Read-only (no fixes).
$ErrorActionPreference = 'SilentlyContinue'
$results = New-Object System.Collections.ArrayList
function Add($area, $status, $detail) { [void]$results.Add([pscustomobject]@{Area = $area; Status = $status; Detail = "$detail" }) }
function Ver($name, $argsList) {
  $c = Get-Command $name
  if (-not $c) { return $null }
  $out = & $c.Source @argsList 2>&1 | Select-Object -First 1
  return "$out".Trim()
}
function Http($url) {
  try { $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec 3 -Uri $url; return $r.StatusCode } catch { return $null }
}

$hermesHome = if ($env:HERMES_HOME) { $env:HERMES_HOME } else { Join-Path $env:LOCALAPPDATA 'hermes' }
$cfg = Join-Path $hermesHome 'config.yaml'

# Hermes
$hv = Ver 'hermes' @('--version')
if ($hv) { Add 'Hermes' 'OK' $hv } else { Add 'Hermes' 'FAIL' 'hermes not on PATH' }
if (Test-Path $cfg) { Add 'Hermes config' 'OK' $cfg } else { Add 'Hermes config' 'FAIL' "missing $cfg" }
$cfgText = if (Test-Path $cfg) { Get-Content $cfg -Raw } else { '' }

# Strata / local model
$h = Http 'http://127.0.0.1:8080/health'
if ($h -eq 200) { Add 'Strata API :8080' 'OK' 'health 200' } else { Add 'Strata API :8080' 'WARN' 'not running (start: strata-hermes.bat or run-<tag>.bat)' }
$tag = 'iq3_xxs'
if (Test-Path "$StrataDir\selected-model.txt") { $tag = (Get-Content "$StrataDir\selected-model.txt" -TotalCount 1).Trim() }
if (Test-Path "$StrataDir\run-$tag.bat") { Add 'Strata install' 'OK' "$StrataDir\run-$tag.bat" }
elseif (Test-Path $StrataDir) {
  $last = ''
  if (Test-Path "$StrataDir\download.log") { $last = ((Get-Content "$StrataDir\download.log" -Tail 1) -split "`r")[-1].Trim() }
  Add 'Strata install' 'WARN' "run-$tag.bat not found (install in progress?) $last"
} else { Add 'Strata install' 'FAIL' "$StrataDir missing" }
if ($cfgText -match '(?m)^\s{2}strata:') { Add 'Provider strata' 'OK' 'providers.strata configured' } else { Add 'Provider strata' 'FAIL' 'providers.strata missing in config.yaml' }
$lm = Http 'http://127.0.0.1:1234/v1/models'
if ($lm -eq 200) { Add 'LM Studio :1234' 'OK' 'API up' } else { Add 'LM Studio :1234' 'WARN' 'not running (lms server start)' }
if ($cfgText -match '(?m)^fallback_providers:') { Add 'Fallback providers' 'OK' 'fallback_providers configured' } else { Add 'Fallback providers' 'WARN' 'no fallback_providers' }
$gpu = Ver 'nvidia-smi' @('--query-gpu=name,memory.used,memory.total', '--format=csv,noheader')
if ($gpu) { Add 'GPU' 'OK' $gpu } else { Add 'GPU' 'WARN' 'nvidia-smi not found' }

# Toolchain
foreach ($t in @(@('python', @('--version')), @('node', @('--version')), @('git', @('--version')), @('gh', @('--version')),
    @('docker', @('--version')), @('wsl', @('--status')), @('winget', @('--version')), @('rg', @('--version')))) {
  $v = Ver $t[0] $t[1]
  if ($v) { Add $t[0] 'OK' ($v -replace "`0", '') } else { Add $t[0] 'WARN' 'not found (fallback skill: find-tool.ps1)' }
}
Add 'PowerShell' 'OK' $PSVersionTable.PSVersion.ToString()
$pw = Ver 'pwsh' @('--version'); if ($pw) { Add 'pwsh' 'OK' $pw } else { Add 'pwsh' 'WARN' 'PowerShell 7 not installed (5.1 is used)' }

# Network / ports
$net = Test-NetConnection -ComputerName github.com -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue
if ($net) { Add 'Network' 'OK' 'github.com:443 reachable' } else { Add 'Network' 'FAIL' 'github.com:443 unreachable' }
foreach ($p in 8080, 1234) {
  $l = Get-NetTCPConnection -LocalPort $p -State Listen
  if ($l) { Add "Port $p" 'OK' "listening (pid $($l[0].OwningProcess))" } else { Add "Port $p" 'WARN' 'not listening' }
}

# Skill / tool registry
$skillsDir = Join-Path $hermesHome 'skills'
$all = @(Get-ChildItem $skillsDir -Recurse -Filter SKILL.md -File)
$manifest = Join-Path $skillsDir '.kiridev_manifest'
$kd = if (Test-Path $manifest) { @(Get-Content $manifest).Count } else { 0 }
if ($kd -gt 0) { Add 'Skill registry' 'OK' "$($all.Count) skills total, $kd KiriDev-synced" } else { Add 'Skill registry' 'FAIL' "KiriDev skills not synced (run scripts\sync-hermes-skills.ps1); total $($all.Count)" }
foreach ($core in 'skill-router', 'permission-policy', 'model-router', 'fallback', 'doctor', 'verify') {
  if (-not ($all | Where-Object { $_.Directory.Name -eq $core })) { Add "Skill $core" 'FAIL' 'missing' }
}
if ($cfgText -match '(?m)^\s+mode:\s*(\w+)' -and $cfgText -match '(?ms)^approvals:') { Add 'Permissions' 'OK' "approvals configured" } else { Add 'Permissions' 'WARN' 'approvals block not found (defaults apply)' }
if ($hv) {
  $auth = (hermes auth list 2>$null | Select-String -Pattern '^\S.*\(\d+ credentials?\)') -join '; '
  Add 'Provider credentials' $(if ($auth) { 'OK' } else { 'WARN' }) ($auth -replace '\s+', ' ')
}

# PATH / env
$dirs = $env:PATH -split ';' | Where-Object { $_ }
$missing = @($dirs | Where-Object { -not (Test-Path $_) })
$dups = @($dirs | Group-Object | Where-Object Count -gt 1)
$st = if ($missing.Count -or $dups.Count) { 'WARN' } else { 'OK' }
Add 'PATH' $st "$($dirs.Count) entries, $($missing.Count) missing, $($dups.Count) duplicated"
$envNames = (Get-ChildItem env: | Where-Object { $_.Name -match '^(HERMES|STRATA|LM_|OPENAI|ANTHROPIC|KIRIDEV)' } | ForEach-Object Name) -join ','
Add 'Env vars' 'OK' $(if ($envNames) { "set: $envNames (values hidden)" } else { 'none of HERMES*/STRATA*/LM_*/OPENAI*/ANTHROPIC* set' })

if ($Json) { $results | ConvertTo-Json -Depth 3; exit 0 }
$results | Format-Table -AutoSize -Wrap | Out-String -Width 200
$fail = @($results | Where-Object Status -eq 'FAIL').Count
$warn = @($results | Where-Object Status -eq 'WARN').Count
"SUMMARY: $($results.Count) checks, $fail FAIL, $warn WARN"
