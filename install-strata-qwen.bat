@echo off
rem One-click installer: Strata (Qwen3.8-Flash-Next IQ2_XS) + Qwen Code.
rem Safe to run again: finished steps are skipped and the model download resumes.
rem Needs about 80 GB free on C: and a few hours for the ~70 GB download.
setlocal
title Install Strata + Qwen Code
set "STRATA_DIR=C:\Strata"
set "MODEL=IQ2_XS"
set "CFG=%STRATA_DIR%\strata-iq2_xs.json"

echo [1/5] Checking git and Node.js ...
where git >nul 2>nul
if errorlevel 1 (
  echo Installing Git for your user account ...
  winget install -e --id Git.Git --scope user --silent --accept-package-agreements --accept-source-agreements
)
where node >nul 2>nul
if errorlevel 1 (
  echo Installing Node.js LTS for your user account ...
  winget install -e --id OpenJS.NodeJS.LTS --scope user --silent --accept-package-agreements --accept-source-agreements
)
rem winget changes PATH only for new windows: look in the usual places
if exist "%ProgramFiles%\Git\cmd" set "PATH=%PATH%;%ProgramFiles%\Git\cmd"
if exist "%LOCALAPPDATA%\Programs\Git\cmd" set "PATH=%PATH%;%LOCALAPPDATA%\Programs\Git\cmd"
if exist "%ProgramFiles%\nodejs" set "PATH=%PATH%;%ProgramFiles%\nodejs"
if exist "%LOCALAPPDATA%\Programs\nodejs" set "PATH=%PATH%;%LOCALAPPDATA%\Programs\nodejs"
where git >nul 2>nul || goto need_restart
where npm >nul 2>nul || goto need_restart

echo [2/5] Getting Strata into %STRATA_DIR% ...
if exist "%STRATA_DIR%\START-HERE.bat" (
  echo Already there.
) else (
  git clone https://github.com/Niko1221/Strata "%STRATA_DIR%" || goto fail
)

echo [3/5] Setting up Strata with %MODEL% (the model download is about 70 GB) ...
if exist "%STRATA_DIR%\run-iq2_xs.bat" (
  echo Already set up.
) else (
  call "%STRATA_DIR%\START-HERE.bat" --yes --family qwen --model %MODEL% --no-start || goto fail
)
if not exist "%STRATA_DIR%\run-iq2_xs.bat" goto fail

echo [4/5] Allowing long replies in the 32K context (fit_max_tokens) ...
findstr /c:"fit_max_tokens" "%CFG%" >nul 2>nul
if errorlevel 1 powershell -NoProfile -Command "(Get-Content -Raw '%CFG%') -replace '\"port\": 8080,', ('\"port\": 8080,' + [Environment]::NewLine + ' \"fit_max_tokens\": true,') | Set-Content -NoNewline '%CFG%'"

echo [5/5] Installing Qwen Code ...
where qwen >nul 2>nul
if errorlevel 1 (
  call npm install -g @qwen-code/qwen-code || goto fail
) else (
  echo Already installed.
)

echo.
echo Done. Start with strata-qwen.bat (next to this file).
pause
exit /b 0

:need_restart
echo.
echo Git or Node.js was just installed. Close this window and run this file again.
pause
exit /b 1

:fail
echo.
echo Install failed. Read the message above, then run this file again (it resumes).
pause
exit /b 1
