@echo off
rem Copy this single file into any project folder: Qwen Code opens in the folder this file is in.
rem Starts the Strata model picked by strata-download.bat, then opens Qwen Code when the server answers.
rem If Strata is already running it is reused (no duplicate start).
rem Only when THIS bat started Strata: Strata stops when Qwen Code exits or this window is closed.
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

curl -s -m 2 http://127.0.0.1:8080/health >nul 2>nul
if not errorlevel 1 goto reuse

netstat -ano | findstr ":8080 " | findstr LISTENING >nul
if not errorlevel 1 goto busy

if not exist "%STRATA_DIR%\run-%TAG%.bat" (
  echo Model %TAG% not found in %STRATA_DIR%. Run strata-download.bat first.
  pause
  exit /b 1
)
echo Starting Strata (%TAG%). First load takes 1-3 minutes and the PC may slow down.
set "STARTED=1"
rem /b keeps the server in this console: closing this window also ends Strata.
start "" /b cmd /c "%STRATA_DIR%\run-%TAG%.bat"
goto wait

:reuse
echo Strata is already running. Reusing it.
goto wait

:busy
echo Port 8080 is in use (Strata may still be loading). Waiting for it.

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
