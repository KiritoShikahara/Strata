@echo off
rem Copy this single file into any project folder: Qwen Code opens in the folder this file is in.
rem Starts the Strata model picked by strata-download.bat, then opens Qwen Code when the server answers.
rem If a Strata server is already running on port 8080 it is stopped first, then started fresh.
rem Strata stops when Qwen Code exits or this window is closed.
rem Qwen Code runs in YOLO mode: every tool call is approved automatically (no prompts).
rem Strata location: the STRATA_DIR environment variable (set by the installer), else C:\Strata.
title Strata + Qwen Code
if not defined STRATA_DIR set "STRATA_DIR=C:\Strata"
set "OPENAI_BASE_URL=http://127.0.0.1:8080/v1"
set "OPENAI_API_KEY=strata"
set "OPENAI_MODEL=strata"
set "TAG=iq3_xxs"
if exist "%STRATA_DIR%\selected-model.txt" set /p TAG=<"%STRATA_DIR%\selected-model.txt"
set "STARTED=0"

where qwen >nul 2>nul
if errorlevel 1 (
  echo Qwen Code is not installed. Run install-strata-qwen.bat first.
  pause
  exit /b 1
)

netstat -ano | findstr ":8080 " | findstr LISTENING >nul
if errorlevel 1 goto start
echo Stopping the previous Strata server on port 8080.
for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":8080 " ^| findstr LISTENING') do taskkill /PID %%p /T /F >nul 2>nul
taskkill /IM strata.exe /F >nul 2>nul
:freewait
netstat -ano | findstr ":8080 " | findstr LISTENING >nul
if errorlevel 1 goto start
"%SystemRoot%\System32\timeout.exe" /t 1 /nobreak >nul
goto freewait

:start
if not exist "%STRATA_DIR%\run-%TAG%.bat" (
  echo Model %TAG% not found in %STRATA_DIR%. Run strata-download.bat first.
  pause
  exit /b 1
)
echo Starting Strata (%TAG%). First load takes 1-3 minutes and the PC may slow down.
set "STARTED=1"
rem /b keeps the server in this console: closing this window also ends Strata.
echo Strata log: %STRATA_DIR%\strata-%TAG%-console.log
start "" /b cmd /c ""%STRATA_DIR%\run-%TAG%.bat" <nul >"%STRATA_DIR%\strata-%TAG%-console.log" 2>&1"

:wait
curl -s -m 2 http://127.0.0.1:8080/health >nul 2>nul
if errorlevel 1 (
  "%SystemRoot%\System32\timeout.exe" /t 5 /nobreak >nul
  goto wait
)
echo Strata is ready. Opening Qwen Code.
cd /d "%~dp0"
call qwen --approval-mode yolo

if "%STARTED%"=="1" (
  echo Stopping Strata.
  for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":8080 " ^| findstr LISTENING') do taskkill /PID %%p /T /F >nul 2>nul
  taskkill /IM strata.exe /F >nul 2>nul
)
