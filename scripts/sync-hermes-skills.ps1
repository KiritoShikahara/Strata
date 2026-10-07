param(
  [string]$HermesHome = $(if ($env:HERMES_HOME) { $env:HERMES_HOME } else { Join-Path $env:LOCALAPPDATA 'hermes' }),
  [switch]$WhatIf
)
# Install/sync the git-managed KiriDev skills (repo skills/) into the Hermes skills dir.
# - Copies skills/<category>/<name>/ -> <HermesHome>/skills/<category>/<name>/ (external/<author>/<name> likewise).
# - Tracks synced dirs in <HermesHome>/skills/.kiridev_manifest and removes dirs that were synced before but no longer exist in the repo.
# - Never touches Hermes bundled / hub / user-created skills that are not in the manifest.
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$src = Join-Path $repo 'skills'
$dst = Join-Path $HermesHome 'skills'
if (-not (Test-Path $dst)) { throw "Hermes skills dir not found: $dst" }
$manifestPath = Join-Path $dst '.kiridev_manifest'
$old = @(); if (Test-Path $manifestPath) { $old = @(Get-Content $manifestPath | Where-Object { $_ }) }

$skillDirs = Get-ChildItem $src -Recurse -Filter SKILL.md -File |
  Where-Object { $_.FullName -notmatch '\\catalog\\' -and $_.FullName -notmatch '\\(references|templates|assets|scripts)\\.*SKILL\.md$' } |
  ForEach-Object { $_.Directory.FullName.Substring($src.Length + 1) } | Sort-Object -Unique
# Only the active set goes into Hermes; the rest is loaded on demand from the repo (skill-router).
$active = @(Get-Content (Join-Path $repo 'hermes\active-skills.txt') | Where-Object { $_ -and $_ -notmatch '^\s*#' } | ForEach-Object { $_.Trim().Replace('/', '\') })
$skillDirs = @($skillDirs | Where-Object { $r = $_; $active | Where-Object { $r -eq $_ -or $r.StartsWith("$_\") } })

$new = @()
foreach ($rel in $skillDirs) {
  $from = Join-Path $src $rel
  $to = Join-Path $dst $rel
  $new += $rel
  if ($WhatIf) { "sync $rel"; continue }
  if (Test-Path $to) { Remove-Item $to -Recurse -Force }
  New-Item -ItemType Directory -Force -Path (Split-Path $to) | Out-Null
  Copy-Item $from $to -Recurse -Force
}
$removed = 0
foreach ($rel in $old) {
  if ($new -notcontains $rel) {
    $p = Join-Path $dst $rel
    if (Test-Path (Join-Path $p 'SKILL.md')) {
      if ($WhatIf) { "remove $rel" } else { Remove-Item $p -Recurse -Force; $removed++ }
    }
  }
}
if (-not $WhatIf) { $new | Set-Content -Encoding ASCII $manifestPath }
"KiriDev skills synced: $($new.Count) (removed $removed) -> $dst"

# Hermes bundled skills that are not needed: hidden via skills.disabled.
$disabled = @(Get-Content (Join-Path $repo 'hermes\disabled-skills.txt') | Where-Object { $_ -and $_ -notmatch '^\s*#' } | ForEach-Object { $_.Trim() })
$json = '[' + (($disabled | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']'
if ($WhatIf) { "set skills.disabled ($($disabled.Count))" } else { hermes config set skills.disabled $json | Out-Null; "Hermes skills disabled: $($disabled.Count)" }

# Always-loaded KiriDev core block in SOUL.md (between markers; the rest of SOUL.md is left untouched).
$soul = Join-Path $HermesHome 'SOUL.md'
$core = (Get-Content (Join-Path $repo 'hermes\kiridev-core.md') -Raw -Encoding UTF8).TrimEnd().Replace('{{KIRIDEV_SKILLS}}', $src)
$begin = '<!-- KIRIDEV:BEGIN (managed by scripts/sync-hermes-skills.ps1) -->'
$end = '<!-- KIRIDEV:END -->'
$text = if (Test-Path $soul) { [IO.File]::ReadAllText($soul) } else { '' }
$block = "$begin`n$core`n$end"
$pattern = [regex]::Escape($begin) + '[\s\S]*?' + [regex]::Escape($end)
if ($text -match $pattern) { $updated = [regex]::Replace($text, $pattern, { param($m) $block }) }
else { $updated = $text.TrimEnd() + "`n`n" + $block + "`n" }
if ($updated -ne $text) {
  if ($WhatIf) { "update $soul" }
  else {
    if (Test-Path $soul) { Copy-Item $soul "$soul.bak.kiridev" -Force }
    [IO.File]::WriteAllText($soul, $updated, (New-Object Text.UTF8Encoding $false))
    "SOUL.md KiriDev core block updated"
  }
}
