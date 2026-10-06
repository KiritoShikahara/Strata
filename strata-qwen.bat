@echo off
rem Strata (IQ2_XS) を起動し、応答できるようになったら Qwen Code を開く
chcp 65001 >nul
title Strata + Qwen Code
set "OPENAI_BASE_URL=http://127.0.0.1:8080/v1"
set "OPENAI_API_KEY=strata"
set "OPENAI_MODEL=qwen3.8-flash-next-iq2_xs"

curl -s -m 2 http://127.0.0.1:8080/health >nul 2>nul
if errorlevel 1 (
  echo Strata を起動します。初回は読み込みに 1-3 分かかり、PC が重くなります。
  start "Strata IQ2_XS" cmd /c "C:\Strata\run-iq2_xs.bat"
)

:wait
curl -s -m 2 http://127.0.0.1:8080/health >nul 2>nul
if errorlevel 1 (
  timeout /t 5 /nobreak >nul
  goto wait
)
echo Strata 応答あり。Qwen Code を開きます。
cd /d "%~dp0"
call qwen
