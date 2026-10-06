@echo off
rem Start Strata (IQ2_XS), then open Qwen Code when the server answers.
rem If Strata is already running it is reused (no duplicate start).
rem Only when THIS bat started Strata: Strata stops when Qwen Code exits or this window is closed.
title Strata + Qwen Code
set "OPENAI_BASE_URL=http://127.0.0.1:8080/v1"
set "OPENAI_API_KEY=strata"
set "OPENAI_MODEL=qwen3.8-flash-next-iq2_xs"
set "STARTED=0"

curl -s -m 2 http://127.0.0.1:8080/health >nul 2>nul
if not errorlevel 1 goto reuse

netstat -ano | findstr ":8080 " | findstr LISTENING >nul
if not errorlevel 1 goto busy

echo Starting Strata. First load takes 1-3 minutes and the PC may slow down.
set "STARTED=1"
rem /b keeps the server in this console: closing this window also ends Strata.
start "" /b cmd /c "C:\Strata\run-iq2_xs.bat"
goto wait

:reuse
echo Strata is already running. Reusing it.
goto wait

:busy
echo Port 8080 is in use (Strata may still be loading). Waiting for it.

:wait
curl -s -m 2 http://127.0.0.1:8080/health >nul 2>nul
if errorlevel 1 (
  timeout /t 5 /nobreak >nul
  goto wait
)
echo Strata is ready. Opening Qwen Code.
cd /d "%~dp0"
call qwen

if "%STARTED%"=="1" (
  echo Stopping Strata.
  for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":8080 " ^| findstr LISTENING') do taskkill /PID %%p /T /F >nul 2>nul
  taskkill /IM strata.exe /F >nul 2>nul
)
