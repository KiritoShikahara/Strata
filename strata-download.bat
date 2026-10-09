@echo off
rem Download (or switch to) a Strata model. Run it any time to add another model.
rem   strata-download.bat          pick from a menu
rem   strata-download.bat 3        pick by number (no menu)
rem   strata-download.bat 1 "D:\old\models\IQ2_XS"   use GGUF files you already have (copied, no download)
rem The model you pick becomes the one strata-qwen.bat / strata-hermes.bat start (saved in %STRATA_DIR%\selected-model.txt).
rem Strata location: the STRATA_DIR environment variable (set by the installer), else C:\Strata.
rem Model files go next to it: %STRATA_DIR%-data (e.g. C:\Strata-data).
setlocal
title Strata model download
if not defined STRATA_DIR set "STRATA_DIR=C:\Strata"
set "DATA_DIR=%STRATA_DIR%-data"
if not exist "%STRATA_DIR%\START-HERE.bat" (
  echo Strata not found at %STRATA_DIR%. Run install-strata-qwen.bat first.
  pause
  exit /b 1
)

set "N=%~1"
if defined N goto pick

echo.
echo  Pick a model (RAM = what the PC needs; the download is 66-76 GB for the sizes below the Coder):
echo.
echo    1  IQ2_XS    39 GB RAM   fast, better quality     48-64 GB
echo    2  Q2_0      38 GB RAM   fastest, good quality
echo    3  IQ3_XXS   47 GB RAM   slower, great quality    RECOMMENDED for 64 GB
echo    4  IQ3_S     55 GB RAM   slowest, best quality    64 GB with little else open
echo    5  Coder     30 GB RAM   code only, fits 32 GB PCs
echo    6  Swift     39 GB RAM   IQ2_XS fine-tune that thinks shorter
echo.
choice /c 123456 /n /m "Number (1-6): "
set "N=%errorlevel%"

:pick
set "FAMILY=qwen"
set "PFX="
if "%N%"=="1" ( set "SIZE=IQ2_XS"  & set "TAG=iq2_xs" )
if "%N%"=="2" ( set "SIZE=Q2_0"    & set "TAG=q2_0" )
if "%N%"=="3" ( set "SIZE=IQ3_XXS" & set "TAG=iq3_xxs" )
if "%N%"=="4" ( set "SIZE=IQ3_S"   & set "TAG=iq3_s" )
if "%N%"=="5" ( set "FAMILY=coder" & set "PFX=coder-" & set "SIZE=IQ1_M"  & set "TAG=coder-iq1_m" )
if "%N%"=="6" ( set "FAMILY=swift" & set "PFX=swift-" & set "SIZE=IQ2_XS" & set "TAG=swift-iq2_xs" )
if not defined TAG (
  echo Unknown choice "%N%". Use a number from 1 to 6.
  pause
  exit /b 1
)

echo.
echo Model: %FAMILY% %SIZE%
rem the refusal-removing projection (experimental-speed-projection) is on by default; Swift does not support it
set "ESP=on"
if "%FAMILY%"=="swift" set "ESP=off"
set "NEED=1"
if exist "%STRATA_DIR%\run-%TAG%.bat" set "NEED=0"
if "%NEED%%ESP%"=="0on" findstr /c:"speed-projection" "%STRATA_DIR%\strata-%TAG%.json" >nul 2>nul || set "NEED=1"
if "%NEED%"=="0" (
  echo Already downloaded and set up. Nothing to download.
) else (
  if not "%~2"=="" (
    echo Copying the model files from %~2 ...
    robocopy "%~2" "%DATA_DIR%\models\%PFX%%SIZE%" *.gguf *.done /J /NP /NJH /NJS
    if errorlevel 8 (
      echo Copy failed.
      pause
      exit /b 1
    )
  )
  echo Setting up. Without local files this downloads 30-76 GB: it can be stopped and resumed by running this file again.
  call "%STRATA_DIR%\START-HERE.bat" --yes --family %FAMILY% --model %SIZE% --context 131072 --no-start --data-dir "%DATA_DIR%" --experimental-speed-projection %ESP%
  if not exist "%STRATA_DIR%\run-%TAG%.bat" (
    echo.
    echo Setup did not finish. Run this file again to resume.
    pause
    exit /b 1
  )
)

rem long replies: shorten max_tokens to the room left in the context instead of failing
findstr /c:"fit_max_tokens" "%STRATA_DIR%\strata-%TAG%.json" >nul 2>nul
if errorlevel 1 powershell -NoProfile -Command "(Get-Content -Raw '%STRATA_DIR%\strata-%TAG%.json') -replace '\"port\": 8080,', ('\"port\": 8080,' + [Environment]::NewLine + ' \"fit_max_tokens\": true,') | Set-Content -NoNewline '%STRATA_DIR%\strata-%TAG%.json'"

rem no sampling block = greedy decoding, which loops on repeated text: set defaults (a request's own fields still win)
findstr /c:"\"sampling\"" "%STRATA_DIR%\strata-%TAG%.json" >nul 2>nul
if errorlevel 1 powershell -NoProfile -Command "(Get-Content -Raw '%STRATA_DIR%\strata-%TAG%.json') -replace '\"port\": 8080,', ('\"port\": 8080,' + [Environment]::NewLine + ' \"sampling\": {\"temperature\": 0.7, \"top_p\": 0.8, \"top_k\": 20, \"presence_penalty\": 1.0},') | Set-Content -NoNewline '%STRATA_DIR%\strata-%TAG%.json'"

> "%STRATA_DIR%\selected-model.txt" echo %TAG%
echo.
echo Done. strata-qwen.bat now starts: %FAMILY% %SIZE%
if "%~1"=="" pause
exit /b 0
