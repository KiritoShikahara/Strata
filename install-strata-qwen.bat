@echo off
rem One-click installer: Strata (Qwen3.8-Flash-Next IQ2_XS) + Qwen Code.
rem Safe to run again: finished steps are skipped and the model download resumes.
rem Context is 131072 tokens (docs: measured on a 12 GB RTX 5070). Needs about 80 GB free on C: and a few hours for the ~70 GB download.
setlocal
title Install Strata + Qwen Code
set "STRATA_DIR=C:\Strata"
set "MODEL=IQ2_XS"
set "CFG=%STRATA_DIR%\strata-iq2_xs.json"

echo [1/6] Checking git and Node.js ...
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

echo [2/6] Getting Strata into %STRATA_DIR% ...
if exist "%STRATA_DIR%\START-HERE.bat" (
  echo Already there.
) else (
  git clone https://github.com/Niko1221/Strata "%STRATA_DIR%" || goto fail
)

echo [3/6] Setting up Strata with %MODEL% (the model download is about 70 GB) ...
if exist "%STRATA_DIR%\run-iq2_xs.bat" (
  echo Already set up.
) else (
  call "%STRATA_DIR%\START-HERE.bat" --yes --family qwen --model %MODEL% --context 131072 --no-start || goto fail
)
if not exist "%STRATA_DIR%\run-iq2_xs.bat" goto fail

echo [4/6] Allowing long replies in the 32K context (fit_max_tokens) ...
findstr /c:"fit_max_tokens" "%CFG%" >nul 2>nul
if errorlevel 1 powershell -NoProfile -Command "(Get-Content -Raw '%CFG%') -replace '\"port\": 8080,', ('\"port\": 8080,' + [Environment]::NewLine + ' \"fit_max_tokens\": true,') | Set-Content -NoNewline '%CFG%'"

echo [5/6] Installing Qwen Code ...
where qwen >nul 2>nul
if errorlevel 1 (
  call npm install -g @qwen-code/qwen-code || goto fail
) else (
  echo Already installed.
)

echo [6/6] Creating strata-qwen.bat next to this file ...
powershell -NoProfile -Command "$o = Get-Content '%~f0' | Where-Object { $_ -like '::| *' } | ForEach-Object { $_.Substring(4) }; Set-Content -Path '%~dp0strata-qwen.bat' -Value $o -Encoding ASCII"
if not exist "%~dp0strata-qwen.bat" goto fail

echo.
echo Done. Start with strata-qwen.bat (created next to this file). You can copy it into any project folder.
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

rem ---- strata-qwen.bat is stored below, one comment line each; step 6 writes it out. Keep it in sync with strata-qwen.bat. ----
::| @echo off
::| rem Copy this single file into any project folder: Qwen Code opens in the folder this file is in.
::| rem Starts Strata (IQ2_XS), then opens Qwen Code when the server answers.
::| rem If Strata is already running it is reused (no duplicate start).
::| rem Only when THIS bat started Strata: Strata stops when Qwen Code exits or this window is closed.
::| rem Strata location: set STRATA_DIR before running to override (default C:\Strata).
::| title Strata + Qwen Code
::| if not defined STRATA_DIR set "STRATA_DIR=C:\Strata"
::| set "OPENAI_BASE_URL=http://127.0.0.1:8080/v1"
::| set "OPENAI_API_KEY=strata"
::| set "OPENAI_MODEL=qwen3.8-flash-next-iq2_xs"
::| set "STARTED=0"
::| 
::| where qwen >nul 2>nul
::| if errorlevel 1 (
::|   echo Qwen Code is not installed. Run install-strata-qwen.bat first.
::|   pause
::|   exit /b 1
::| )
::| 
::| curl -s -m 2 http://127.0.0.1:8080/health >nul 2>nul
::| if not errorlevel 1 goto reuse
::| 
::| netstat -ano | findstr ":8080 " | findstr LISTENING >nul
::| if not errorlevel 1 goto busy
::| 
::| if not exist "%STRATA_DIR%\run-iq2_xs.bat" (
::|   echo Strata not found at %STRATA_DIR%. Run install-strata-qwen.bat first.
::|   pause
::|   exit /b 1
::| )
::| echo Starting Strata. First load takes 1-3 minutes and the PC may slow down.
::| set "STARTED=1"
::| rem /b keeps the server in this console: closing this window also ends Strata.
::| start "" /b cmd /c "%STRATA_DIR%\run-iq2_xs.bat"
::| goto wait
::| 
::| :reuse
::| echo Strata is already running. Reusing it.
::| goto wait
::| 
::| :busy
::| echo Port 8080 is in use (Strata may still be loading). Waiting for it.
::| 
::| :wait
::| curl -s -m 2 http://127.0.0.1:8080/health >nul 2>nul
::| if errorlevel 1 (
::|   timeout /t 5 /nobreak >nul
::|   goto wait
::| )
::| echo Strata is ready. Opening Qwen Code.
::| cd /d "%~dp0"
::| call qwen
::| 
::| if "%STARTED%"=="1" (
::|   echo Stopping Strata.
::|   for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":8080 " ^| findstr LISTENING') do taskkill /PID %%p /T /F >nul 2>nul
::|   taskkill /IM strata.exe /F >nul 2>nul
::| )
