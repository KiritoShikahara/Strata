@echo off
setlocal
set "CC_ADHD=1"
rem Thin wrapper: ultra profile + i-have-adhd pinned to opus. After install.bat, copy this file alone into any project folder and run it there.
set "CC_MODEL=opus"
set "CLAUDE_CODE_EFFORT_LEVEL=low"
set "BASE=%~dp0..\claude-1-ultra.cmd"
if not exist "%BASE%" if exist "%USERPROFILE%\.claude-ctxkit\root.txt" set /p CTXKIT_ROOT=<"%USERPROFILE%\.claude-ctxkit\root.txt"
if not exist "%BASE%" set "BASE=%CTXKIT_ROOT%\account1\claude-1-ultra.cmd"
if not exist "%BASE%" (echo ctx-kit not found. Run install.bat in the ClaudeContext folder first. & pause & exit /b 1)
if "%~1"=="" (call "%BASE%" "%~dp0.") else (call "%BASE%" %*)
