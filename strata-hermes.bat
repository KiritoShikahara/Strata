@echo off
rem Copy this single file into any project folder: Hermes opens in the folder this file is in.
rem Starts the Strata model picked by strata-download.bat, then opens Hermes when the server answers.
rem If Strata is already running it is reused (no duplicate start).
rem Only when THIS bat started Strata: Strata stops when Hermes exits or this window is closed.
rem Hermes runs with --yolo: every tool call is approved automatically (no prompts).
rem Hermes uses the "strata" provider in %LOCALAPPDATA%\hermes\config.yaml (providers.strata).
rem Strata location: set STRATA_DIR before running to override (default D:\Strata).
title Strata + Hermes
if not defined STRATA_DIR set "STRATA_DIR=D:\Strata"
set "TAG=iq3_xxs"
if exist "%STRATA_DIR%\selected-model.txt" set /p TAG=<"%STRATA_DIR%\selected-model.txt"
set "STARTED=0"

where hermes >nul 2>nul
if errorlevel 1 (
  echo Hermes is not installed.
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
  timeout /t 5 /nobreak >nul
  goto wait
)
echo Strata is ready. Opening Hermes.
cd /d "%~dp0"
call hermes chat --provider strata -m strata --yolo

if "%STARTED%"=="1" (
  echo Stopping Strata.
  for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":8080 " ^| findstr LISTENING') do taskkill /PID %%p /T /F >nul 2>nul
  taskkill /IM strata.exe /F >nul 2>nul
)
