@echo off
setlocal
rem Launch a Sonnet (ultra + i-have-adhd) Claude Code console in the given project folder.
rem Usage: launch.cmd "<project folder>"
set "PROJ=%~1"
if "%PROJ%"=="" set "PROJ=%CD%"
if exist "%PROJ%\claude-1-ultra-sonnet-adhd.cmd" (
  call "%PROJ%\claude-1-ultra-sonnet-adhd.cmd" "%PROJ%"
  exit /b
)
set "CC_MODEL=sonnet"
set "CC_ADHD=1"
if exist "%USERPROFILE%\.claude-ctxkit\root.txt" set /p CTXKIT_ROOT=<"%USERPROFILE%\.claude-ctxkit\root.txt"
set "BASE=%CTXKIT_ROOT%\account1\claude-1-ultra.cmd"
if not exist "%BASE%" (echo ctx-kit not found. Run install.bat in the ClaudeContext folder first. & pause & exit /b 1)
call "%BASE%" "%PROJ%"
