@echo off
rem One-click installer: Strata + the model you pick + Qwen Code, all from this single file.
rem   install-strata-qwen.bat        pick the model from a menu
rem   install-strata-qwen.bat 2      pick by number (see the menu), no question
rem   install-strata-qwen.bat 1 "E:\models\IQ2_XS"   use GGUF files you already have (copied, no model download)
rem Safe to run again: finished steps are skipped and the model download resumes.
rem It also writes strata-download.bat (add or switch models later) and strata-qwen.bat (the launcher) next to this file.
rem Strata goes to C:\Strata by default; the menu's [B] opens a folder picker to put it elsewhere.
rem The models go next to it (C:\Strata-data). The place is saved as the user environment variable STRATA_DIR,
rem so a strata-qwen.bat copied into any folder finds Strata.
rem Needs about 80 GB free per model and a few hours for the 66-76 GB download. Context is 131072 tokens.
setlocal
title Install Strata + Qwen Code
if not defined STRATA_DIR set "STRATA_DIR=C:\Strata"
if not "%~1"=="" goto place_done
echo.
echo  Install Strata to %STRATA_DIR% (models in %STRATA_DIR%-data)?
choice /c YB /n /m "[Y] yes  [B] browse for another folder: "
if errorlevel 2 call :browse
:place_done
setx STRATA_DIR "%STRATA_DIR%" >nul
echo Strata folder: %STRATA_DIR%
set "STRATA_NOPAUSE=1"

echo [1/7] Checking git and Node.js ...
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

echo [2/7] Getting Strata into %STRATA_DIR% ...
if exist "%STRATA_DIR%\START-HERE.bat" (
  echo Already there.
) else (
  git clone https://github.com/Niko1221/Strata "%STRATA_DIR%" || goto fail
)

echo [3/7] Writing strata-download.bat and downloading the model ...
powershell -NoProfile -Command "$o = Get-Content '%~f0' | Where-Object { $_ -like '::+ *' } | ForEach-Object { $_.Substring(4) }; Set-Content -Path '%~dp0strata-download.bat' -Value $o -Encoding ASCII"
if not exist "%~dp0strata-download.bat" goto fail
call "%~dp0strata-download.bat" %1 %2 || goto fail

echo [4/7] Installing Qwen Code ...
where qwen >nul 2>nul
if errorlevel 1 (
  call npm install -g @qwen-code/qwen-code || goto fail
) else (
  echo Already installed.
)

echo [5/7] Creating strata-qwen.bat next to this file ...
powershell -NoProfile -Command "$o = Get-Content '%~f0' | Where-Object { $_ -like '::| *' } | ForEach-Object { $_.Substring(4) }; Set-Content -Path '%~dp0strata-qwen.bat' -Value $o -Encoding ASCII"
if not exist "%~dp0strata-qwen.bat" goto fail

echo [6/7] Installing Qwen Code skills into %USERPROFILE%\.qwen\skills ...
powershell -NoProfile -Command "$b = (Get-Content '%~f0' | Where-Object { $_ -like '::# *' } | ForEach-Object { $_.Substring(4) }) -join ''; $z = Join-Path $env:TEMP 'qwen-skills.zip'; [IO.File]::WriteAllBytes($z, [Convert]::FromBase64String($b)); $d = Join-Path $env:USERPROFILE '.qwen\skills'; New-Item -ItemType Directory -Force $d | Out-Null; Expand-Archive -Force $z $d; Remove-Item $z" || goto fail

echo [7/7] Setting Qwen Code to never stop (auto-compaction, no turn or token limits, 131072 window) ...
powershell -NoProfile -Command "$b = (Get-Content '%~f0' | Where-Object { $_ -like '::~ *' } | ForEach-Object { $_.Substring(4) }) -join ''; $j = Join-Path $env:TEMP 'qwen-settings.js'; [IO.File]::WriteAllBytes($j, [Convert]::FromBase64String($b)); node $j; $e = $LASTEXITCODE; Remove-Item $j; exit $e" || goto fail

echo.
echo Done. Start with strata-qwen.bat (next to this file). Copy it into any project folder to use it there.
echo To add or switch models later, run strata-download.bat (next to this file).
pause
exit /b 0

:browse
set "PICKED="
for /f "usebackq delims=" %%i in (`powershell -NoProfile -STA -Command "Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.FolderBrowserDialog; $d.Description = 'Pick where to put the Strata folder (a Strata folder is created inside)'; if ($d.ShowDialog() -eq 'OK') { $d.SelectedPath }"`) do set "PICKED=%%i"
if not defined PICKED exit /b 0
if /i "%PICKED:~-7%"=="\Strata" (set "STRATA_DIR=%PICKED%") else (set "STRATA_DIR=%PICKED%\Strata")
if "%PICKED:~-1%"=="\" set "STRATA_DIR=%PICKED%Strata"
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

rem ---- strata-qwen.bat: lines starting with "::| " ----
::| @echo off
::| rem Copy this single file into any project folder: Qwen Code opens in the folder this file is in.
::| rem Starts the Strata model picked by strata-download.bat, then opens Qwen Code when the server answers.
::| rem If Strata is already running it is reused (no duplicate start).
::| rem Only when THIS bat started Strata: Strata stops when Qwen Code exits or this window is closed.
::| rem Qwen Code runs in YOLO mode: every tool call is approved automatically (no prompts).
::| rem Strata location: the STRATA_DIR environment variable (set by the installer), else C:\Strata.
::| title Strata + Qwen Code
::| if not defined STRATA_DIR set "STRATA_DIR=C:\Strata"
::| set "OPENAI_BASE_URL=http://127.0.0.1:8080/v1"
::| set "OPENAI_API_KEY=strata"
::| set "OPENAI_MODEL=strata"
::| set "TAG=iq3_xxs"
::| if exist "%STRATA_DIR%\selected-model.txt" set /p TAG=<"%STRATA_DIR%\selected-model.txt"
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
::| if not exist "%STRATA_DIR%\run-%TAG%.bat" (
::|   echo Model %TAG% not found in %STRATA_DIR%. Run strata-download.bat first.
::|   pause
::|   exit /b 1
::| )
::| echo Starting Strata (%TAG%). First load takes 1-3 minutes and the PC may slow down.
::| set "STARTED=1"
::| rem /b keeps the server in this console: closing this window also ends Strata.
::| start "" /b cmd /c "%STRATA_DIR%\run-%TAG%.bat"
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
::|   "%SystemRoot%\System32\timeout.exe" /t 5 /nobreak >nul
::|   goto wait
::| )
::| echo Strata is ready. Opening Qwen Code.
::| cd /d "%~dp0"
::| call qwen --approval-mode yolo
::| 
::| if "%STARTED%"=="1" (
::|   echo Stopping Strata.
::|   for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":8080 " ^| findstr LISTENING') do taskkill /PID %%p /T /F >nul 2>nul
::|   taskkill /IM strata.exe /F >nul 2>nul
::| )
rem ---- strata-download.bat: lines starting with "::+ " ----
::+ @echo off
::+ rem Download (or switch to) a Strata model. Run it any time to add another model.
::+ rem   strata-download.bat          pick from a menu
::+ rem   strata-download.bat 3        pick by number (no menu)
::+ rem   strata-download.bat 1 "D:\old\models\IQ2_XS"   use GGUF files you already have (copied, no download)
::+ rem The model you pick becomes the one strata-qwen.bat / strata-hermes.bat start (saved in %STRATA_DIR%\selected-model.txt).
::+ rem Strata location: the STRATA_DIR environment variable (set by the installer), else C:\Strata.
::+ rem Model files go next to it: %STRATA_DIR%-data (e.g. C:\Strata-data).
::+ setlocal
::+ title Strata model download
::+ if not defined STRATA_DIR set "STRATA_DIR=C:\Strata"
::+ set "DATA_DIR=%STRATA_DIR%-data"
::+ if not exist "%STRATA_DIR%\START-HERE.bat" (
::+   echo Strata not found at %STRATA_DIR%. Run install-strata-qwen.bat first.
::+   pause
::+   exit /b 1
::+ )
::+ 
::+ set "N=%~1"
::+ if defined N goto pick
::+ 
::+ echo.
::+ echo  Pick a model (RAM = what the PC needs; the download is 66-76 GB for the sizes below the Coder):
::+ echo.
::+ echo    1  IQ2_XS    39 GB RAM   fast, better quality     48-64 GB
::+ echo    2  Q2_0      38 GB RAM   fastest, good quality
::+ echo    3  IQ3_XXS   47 GB RAM   slower, great quality    RECOMMENDED for 64 GB
::+ echo    4  IQ3_S     55 GB RAM   slowest, best quality    64 GB with little else open
::+ echo    5  Coder     30 GB RAM   code only, fits 32 GB PCs
::+ echo    6  Swift     39 GB RAM   IQ2_XS fine-tune that thinks shorter
::+ echo.
::+ choice /c 123456 /n /m "Number (1-6): "
::+ set "N=%errorlevel%"
::+ 
::+ :pick
::+ set "FAMILY=qwen"
::+ set "PFX="
::+ if "%N%"=="1" ( set "SIZE=IQ2_XS"  & set "TAG=iq2_xs" )
::+ if "%N%"=="2" ( set "SIZE=Q2_0"    & set "TAG=q2_0" )
::+ if "%N%"=="3" ( set "SIZE=IQ3_XXS" & set "TAG=iq3_xxs" )
::+ if "%N%"=="4" ( set "SIZE=IQ3_S"   & set "TAG=iq3_s" )
::+ if "%N%"=="5" ( set "FAMILY=coder" & set "PFX=coder-" & set "SIZE=IQ1_M"  & set "TAG=coder-iq1_m" )
::+ if "%N%"=="6" ( set "FAMILY=swift" & set "PFX=swift-" & set "SIZE=IQ2_XS" & set "TAG=swift-iq2_xs" )
::+ if not defined TAG (
::+   echo Unknown choice "%N%". Use a number from 1 to 6.
::+   pause
::+   exit /b 1
::+ )
::+ 
::+ echo.
::+ echo Model: %FAMILY% %SIZE%
::+ if exist "%STRATA_DIR%\run-%TAG%.bat" (
::+   echo Already downloaded and set up. Nothing to download.
::+ ) else (
::+   if not "%~2"=="" (
::+     echo Copying the model files from %~2 ...
::+     robocopy "%~2" "%DATA_DIR%\models\%PFX%%SIZE%" *.gguf *.done /J /NP /NJH /NJS
::+     if errorlevel 8 (
::+       echo Copy failed.
::+       pause
::+       exit /b 1
::+     )
::+   )
::+   echo Setting up. Without local files this downloads 30-76 GB: it can be stopped and resumed by running this file again.
::+   call "%STRATA_DIR%\START-HERE.bat" --yes --family %FAMILY% --model %SIZE% --context 131072 --no-start --data-dir "%DATA_DIR%"
::+   if not exist "%STRATA_DIR%\run-%TAG%.bat" (
::+     echo.
::+     echo Setup did not finish. Run this file again to resume.
::+     pause
::+     exit /b 1
::+   )
::+ )
::+ 
::+ rem long replies: shorten max_tokens to the room left in the context instead of failing
::+ findstr /c:"fit_max_tokens" "%STRATA_DIR%\strata-%TAG%.json" >nul 2>nul
::+ if errorlevel 1 powershell -NoProfile -Command "(Get-Content -Raw '%STRATA_DIR%\strata-%TAG%.json') -replace '\"port\": 8080,', ('\"port\": 8080,' + [Environment]::NewLine + ' \"fit_max_tokens\": true,') | Set-Content -NoNewline '%STRATA_DIR%\strata-%TAG%.json'"
::+ 
::+ > "%STRATA_DIR%\selected-model.txt" echo %TAG%
::+ echo.
::+ echo Done. strata-qwen.bat now starts: %FAMILY% %SIZE%
::+ if "%~1"=="" pause
::+ exit /b 0
rem ---- qwen-skills.zip as base64: lines starting with "::# " ----
::# UEsDBBQAAAAAAEo+R10AAAAAAAAAAAAAAAAHACAAY29tbWl0L3V4CwABBAAAAAAEAAAAAFVUDQAH
::# LHvFav/VxWose8VqUEsDBBQACAAIAEo+R10AAAAAAAAAAAAAAAAPACAAY29tbWl0L1NLSUxMLm1k
::# dXgLAAEEAAAAAAQAAAAAVVQNAAcse8VqQs7Faix7xWpdUstu2zAQvBvwPyycHmLAZNFHekiLAkaT
::# Pg7tIUnRQ1FAjLQSCVGkQFJO/PcdUoob9GBYJHdnZ2ZHCLFeOTXwJdV+GExarxqOdTBjMt5d0uY2
::# qY5JWUu1Vq7jSMo1Sy09mKRJ4eRqEzn/H9jlRmXFUjJwjBlhUKnWxnUUePSkTUw+HOVmvVKhmwZ0
::# CbwmDPztxxnh1OoD5bc/KBaZ7np1dkZ3Kvb587MJMVGYHFUdxsWk0hRJxPtqN980pm3p6/X+ioTI
::# r1URUJ6s73DpHVvjmMRFRedF0YNWiQ8cKGqG8OS9JQPhB2Wsure8xRV1KmmUQHPixyQzl0+z5GLW
::# FAJEnUw7T0HVPTdl+OSW05aMI8xf/CwgryR9ayljw3b8nH8C2VFUR4q+YMC/EfWvUe3iyHX6Ty1k
::# RnLMDWaC7eQahlG5E9ALIvrfSLrymFGcg9etsWCbYADc8T1Z0zNFrgMniKgkuwOMxbHJi1YWpHo+
::# xu17GubNgxw49mYcuQH+W0m/gkmQknWKYvTTXqE9c4lIH6YfLb+0YDWVvEXkpC4GFmcwm2UnqWpZ
::# ISRSyrze1jyevmvtA8+nbXGwerG/+fLz+/WPu9sqb68zyOaOJuQ07yiW2c8ihhtVcgbWF3J2UzUN
::# iT1iMRiHVC2yZpO2/3K0RF0MtPmwIH7cVMB5J+kGcQ9pFqrzl1ZRl9ZnNuQIZGtOyxinqNH/F1BL
::# Bwjbz9o/GAIAAJ4DAABQSwMEFAAAAAAASj5HXQAAAAAAAAAAAAAAAAcAIABjb21wdXMvdXgLAAEE
::# AAAAAAQAAAAAVVQNAAcse8Vq/9XFaix7xWpQSwMEFAAIAAgASj5HXQAAAAAAAAAAAAAAAA8AIABj
::# b21wdXMvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AByx7xWpCzsVqLHvFal2TQW/TQBCF75Hy
::# H55SDknIugLEJVSVKlqgBwoq5YSQvLXH9pL1rrW7Tpp/3xk7aYCbvTOefe97Y6XUdOJ0S2sUvu36
::# OJ2UFItgumS8W2P20betSdDWomi0qylCuxLc2SA1hKIPgVzCY9CuaDA/L8YPuOZwLm2LbDad6FD3
::# LfepxrjEY3/54QJt0VKMuib4AKn95mYloqaTszM86LiRx08mxITQO+Q1D49Jpz5Cxcd8NZ6Upqrw
::# 5ebqGkpJNR9UDiXraz70jqxxBPU+x3xnUoNdoxNtKSA2xO6S9xaG3W21sfrR0oKPUGs2EpiNS/SU
::# MtHyJsNyOWJZLjGPG9PBVAOMnQ8b42qkQCSzCkvaLdbTCQCFWxc7KtJ/gllphCMqqcwOjdcezg8u
::# mUtlLDNPLJad+A2s2RAiFYFSxDzPyG0ZAr+WjNdoG1fY0D4uPkB4M2MmsYeo7E43fHOkBhxH+sYN
::# BiJvAt+7t3RuOexeSiwvUCEZj9HGDLcV8ldX959/fr25e/iRi9XabMmt0EeeleQbGfdXtnyih4CP
::# EgYKuiyhrjiR1jgO9KBy9Lw4RXjYKdVidnGYeTnLedJbyeI7L9ly+UK5EniNxCBpNqRL+Ap9FzkV
::# 3a7YI+Pww/CYfPePHtnXXNI8toOeTEzM1Mse7Azbe2mE6tmZqZndxbj+l/lx2t2wWZUPBSnpHZgF
::# +sP5U7nip86H4ScBhSB4TmreZbgfyzyY11bopZ2H5BXXRxaNZgGvj4RXp58yUOytUH4GUEsHCJ+2
::# YQE/AgAA2wMAAFBLAwQUAAAAAABKPkddAAAAAAAAAAAAAAAACAAgAGZlYXR1cmUvdXgLAAEEAAAA
::# AAQAAAAAVVQNAAcse8Vq/9XFaix7xWpQSwMEFAAIAAgASj5HXQAAAAAAAAAAAAAAABAAIABmZWF0
::# dXJlL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQNAAcse8VqQs7Faix7xWqFVttOG0kQfUfyP7SS
::# lSJZMYhEkVZotVISohVaZRXl8hRFwgsDWIDN+pIoUh6mZ8DY2MTEYHMx95uNARtIlnXA4H9Ju2fG
::# T/mFreoeX3Ck3RfTzHRXVZ9z6tS4XC5Hh9c9rvSQIcUdDPkVR8egEhjweyaCHp+3h9wx0ifWfsI4
::# 2LD0K6YlmRq39mn18px8CyeJlTu2chGxZFqFaV+ZVuSRsJXdEc94YcPamWLqLKOF2maY0WxNPWMa
::# ZVqMT+3xxA7TPjN9nenwG2Wq9mJCGSC/e4IE9pMA/DPqCbr8yl8hj1+BZ1nxrHN8sGtizO3Fv0F3
::# YDQAC8ierF6tMm2GqZTp+0wvM+0cfs3tCys/y6/jjB6S5m56wOgM7LYLpMtQEeR3udyhoK+RCbPj
::# A69v3BcKfC9HrM95nkowmmd0ETYZq6qIfA3r7+UopOCRaYhqZCqMRmTIPu9b36hC3nmCI6TLhpj8
::# IuG08kfG0scPL549eezq6/2VvJb538CxO44Ot384NK54g64RjzfYQ27dOEQ+kB+O3QLqPAH3n2OK
::# a9w3qIy5PJB7wC15DPpDQO2YZ0DxBoDsp30vHR3jStA96A66exwdBMAZDkAWpOAu6VUCnmHvXfIS
::# EHvkV9yjg7538C++BHpu4X4IrAz7/O/hzITfNxgaCHreeoLv4Z0LNeXouN1UlKODF6+t060e4nT+
::# 9PD5b6+ePvnj5QunU7wpp4zUCaNx8+ACkdVACLR6laozGmM0ButuawuQztYZAPj3jeNtxF7ALBLe
::# Jjw6ayTmmA4KyzJdBzXii+5OwvQ809eYVmJ6BNeghv5O5Ngz9L6rHxiH4JpMJiXT0IRg+xPTYMMJ
::# aRFo3FjN85OPoGNGc9XyGjKu0v421UJobIpjph+CpuV+IxoTzXDIr+cZ3YGb1OPgrZgWYXSyrQ7Q
::# Ho+twUE81dwMlU2i8PD+9zpJA0rSL8SB98rybEyixDe/8DmIXTQWt/nxUvUyZWSXGC1BXVblysot
::# Mf3SPF9hFHLmbISjp4yGm/AyfRs7S4+Shz2kpq7wUgkq65f6w2zYGFCQDbrTKa0CAkujgEWbTTid
::# PeS/MbPR0pKt3YZ9i3pYrEOOXY2OYxuDWNfbHeMlzYUNIwLKuDQyX8DSGvSilImLDIy5/SAFBAwQ
::# ssuG5Jm0sZQ1oRy6KVSQrAvQZgWL2s0+wEcqrdGSMbNuaSDLXYCxzoxIUC8MCMQEAg48n43Jspg+
::# LUyrIjCexrsjWLvojfgwJRRdRmTgDh+3zIWcMaNaW6CgnDkXNhdOMZ2W5BWwsxU+dyhttllAi/kV
::# uxssdItSC8buqpUr80QRTZ7mofGMvWPhZ0iSxJnpYZE90jiM6W4kuoec27rVzoRUIsiwtFloTghZ
::# vdyrlrCjzQ3IkIB2NXcv7AxqXO6spWNCtjf6AccI+ADPrEsy2vrUvmaDOliYX6A7IvdBKZCUh6eE
::# MuUuKUe5S/sKux7UNqfMTKF9Y+OuorFySHcEWr1wvwmCSnE+5rZEtJh5AFWCk8wguctaLT0vh4Oj
::# 4z6CI++HmBjRiig/JaxlA3yv2QjNoXOzFwCgZyPugEIe1zFtEcaFnLN1d8mSG8OxNCN8NGqcR3g8
::# 3Y4an5tsXogWG1R3MX1eSDGK406IxGZFBGsVVaHVdTHj5ZLomJYsdcspmMVJnjkDoHH95QSD0Uke
::# 2TXSx9gc03nQHSY8vUBxqZRvnvJPcIFDcKla/Kyl+jZbegRuYrsRvvtfQBvmwiiyKszlum4udos3
::# rEHT2qQNT1rmEZox1NRiGcJpCytc3UX7kpeh+/WPGNK4T90o5AibOgVnxWEROQcB41OQoZ5m+oH4
::# ToIQBexP4RrwvSE+Noot4yDSHFKSTxx9i1gujcuJSt75/KNBv6II2milelUBO6lX4SImTIqdGXNl
::# EjPspmt6js99AjKN+VkIABmGfP4BhUyEAiNIztQR9Cssnj3v6gsEQgqxywNDhEle2RKfRkWJqvSA
::# H1oXFDh9wWcyArM9Y/XIyq/DeZxipK8XLcseaa9fverr/dnYom/6Cb/a5uWEfb7FnZK8fGqbEljl
::# 6ga/npIUMD0hdSI+O8VClgDbpLa1ZG0HihDjgc6LOQizJl69CItROCncu8m1TZn5t4Y7ljVkTUhV
::# DEC4LjgKHlHj+EFD4zwGvwnhaGERKi/m/4btbjRnHUBnLRrpryiYTAlnsUrFUAb895vWebJlXC2I
::# yFpj1so6G23sdJJv6sKNDjVTeZ74B9KQ/iHPmNIz5vEq/bZrG4VY+1HjCD2tWlLFdwdONNvE2huU
::# bsjeJV2kWlkzU8tyIOH33b9QSwcIw/QXUswGAABgDAAAUEsDBBQAAAAAAEo+R10AAAAAAAAAAAAA
::# AAAIACAAaGFuZG9mZi91eAsAAQQAAAAABAAAAABVVA0AByx7xWr/1cVqLHvFalBLAwQUAAgACABK
::# PkddAAAAAAAAAAAAAAAAEAAgAGhhbmRvZmYvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AByx7
::# xWpCzsVqLHvFanVWT28bRRS/R8p3eEo52JZ3LVp6MVGkqGlJQUmqNhVCCGUnu2N78HpmNTNr41vS
::# 0qqllBNFqgQSRQikgnqsEK3U74KTlJ76Ffi92XXSFOgh9c7OvPd+f96bjaJocUGLkezSQOjM9HqL
::# C5l0qVWFV0Z3aemaGEvyA0lpaa3UnibGDsl54SX1jCUrXTlSuk9Gk9AGOy1dudCliVXYEddRO+ur
::# m2tbly7Fo4wamdGSOjg5Ekrz0Q4fHpg8wy8tv/AIL4tmm9NqSs1opDzJsbRTP+DtCElF6QYxXeXk
::# kmTu5ASJJU2UH1CnKPO8OtwpVDosi3hpcUHYPvZqHyGGB7BPTYAockLVFRaGWeWXzuHdZzgWMUOL
::# C2fO0LZwQ/55xcpCWCZFOYAojFPe2Ck5EwIEflKhaVdW5MjsNDencR2D4dCXlHWebKkp6SsfWC4d
::# RW43aVcrmer1aP3i6hpFEb+dr+emjxXwmitwG51PQtx5EDegXDmfUCPwMxlAPNBJbiCZKGNyAhQx
::# FioXu7lshlrejanV+jioyLBqIQNZrRYJT8l/iIsUqZWiPnOyIwG/eYaUqkcjBXJ1/30yqGFynKCw
::# cqwM4HKGZkzX3WnfpUZjvxMsGiiEGJ0iB804P3KgYXtrbStU0KHEFTJ1nVarw9scr7YDIRxvTqyM
::# qUKHZ6XpQ1EILZ1s80OQ1g1EIbtMBRElSRL+P0OHzx/M9u+/fPpwtv8NNZY/wb9oYyNaW6P19e7G
::# xgryL+9aodPBSrM+fPT7o9n+k4M/9o7u3uvSMtsfaEAUsouUAUEELsr6ysG8gFLnjlmp48CEh0++
::# PvjzdniKKI5jaiQ9lcsu654QPFzZqjnff/Tk3uzGV6+f3zn88vHhrTuvfrw9u/ns6Pu9w59/PX/w
::# 7Onr53dPYs3PHLz44eWDh/X6MlO4Qn/tfUvLbJxAl6OJUJ57EW2zclzb7fuvvrs32//t8MWtv3/Z
::# n+0/nt24AeDzSE76sjgFDN0mM9cF5QAPK3Lx0AlySj2msbAuECM9NXhIORCTT9s4xe4di7yUDmOC
::# CQi2Yekg78qJYuHX5R4l76xe/eD6xsXN7WsJl99XYwkXiSxjPKVmayaAMLv5aHbzpySmj6Qs+JUb
::# GOth1TCCRoVHm8ugmAtNcpabZEMMJbnSygAH7V4VxDOiKqjV6tYcXKiaQ+hp3RCu9r75HGErOrAC
::# mtmmE1NiJmbWFBgmqSirjpiGyFUxDUYg0GjYPkTJCehgjrjPUpNJdkRmUp5TPcxHnYYIo7gu55oX
::# fVQD5kvtrUiHKD7Mr4AgpjVDm1vb7ExsA3A41sFxMdRpoaXwnKE1lcih2FBO8debodSuyXl3S5Vn
::# nVSkLHjpixIqJhpF7YxMViI+D6+dnWIatuzs8GPGY6rN48xhBEA4V6aDN/gMIve1QeJKPUbDHgkM
::# VG+SYCcpstDyPPiqXUr/a5DNlf8/5yZv+q45Z4399PZkVZUBgypt4ntG1U0cdiFEnT6kbcwX55j4
::# BpBZNXjPsacuhDaGcapUDDVaRTm4ajEi3VAVxdxozZNZX98p0YiWUhj35FZH87GRQScazE5XlpJ5
::# Pc5Pc+jTg0PSasxyiMrd73ElV1DacR1cJ/SBusePFJV4Vn3Em8+9hO2nDZWF8zD8KKbN0LEYFqmM
::# qqv7Mmdk07OSfIvaIBNJaxGdETkP3+NjIRA0krYf3GzlrnD1FXWevwDCSSQ/yzY4RzwIMVFqJgag
::# uV2VyXdx7k/ugepuDp8a7u2BC7ThIyKpruqk/oxIkPUfUEsHCG21ChE2BQAAMgkAAFBLAwQUAAAA
::# AABKPkddAAAAAAAAAAAAAAAADwAgAGhhbmRvZmYtc29ubmV0L3V4CwABBAAAAAAEAAAAAFVUDQAH
::# LHvFav/VxWose8VqUEsDBBQACAAIAEo+R10AAAAAAAAAAAAAAAAZACAAaGFuZG9mZi1zb25uZXQv
::# bGF1bmNoLmNtZHV4CwABBAAAAAAEAAAAAFVUDQAHLHvFakLOxWose8VqjVLPa4MwFL4L/g+PgKNl
::# aPE66linjnXr6LAt7CCUNMbqZpOiz+Jpf/ti1HXdqZeEJO9734+XB84yCTJNTaPiWEhGC9Mo+QEW
::# tBYsAworKQRHGNUFlhRuIbczeuI2TbJkDH5B64SDL9XCpKhkwSEXgBmHfX7iAo6l/OQMIZVFwkun
::# 672p6J7fQaEpHHZIgEwvC++J1gPkPVq+eNa3q855CsRqzxbxPELgz7sfWF0Bb/IKh7KYaXW2a2vt
::# dqWdaOUtKYGRaQAox8XViEFAC1RcCJOdaYx7rb6/fVsG4cLrYOR8PQueA8+9lLhZhZFq9jRfhFbs
::# 9MQMm68c41JKdLDBzuTkCP7643W+3kbL5dqbXont6R9nq1AldG5gxZQxWQt0/9nVFrVGIfFXZ4u3
::# VFb6oygOW5HoglT1SByIaqFGXqGK0dlRHMbf/QxfCuTNMFVI87JCB27gSOuKq73PEFyVYT+Inu+c
::# 9A9QSwcIaldqqmcBAACjAgAAUEsDBBQACAAIAEo+R10AAAAAAAAAAAAAAAAXACAAaGFuZG9mZi1z
::# b25uZXQvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AByx7xWpCzsVqLHvFao1X308b1xJ+R+J/
::# OKK3aq9v1hZt74uFkKJLEqKWpgrtw5XyYMfewApjc+112kh98O4CsWPCr8QQwCSBEGxMsMMNIQ4Y
::# +F96vD946r/QmTlrvE4TtXlITvbMmTPzzTffGUuS1N0VD4/LQTYajkcTd+5IqUQ8LqvdXVE5FUkq
::# E6qSiAfZFzcm0inGtRIbnpAj7FtFhf9UnW2teXzIfpteZE55zylnacn1M66/53rNzE47pRe/N7Ip
::# OOMfjwYmYuE4/quGU2MpWPzeyHHtFLxa9Swt1nhG87uBBAYvfz9w4+pVsIO7ds1GgWsP7cMVrs1y
::# Y4Mbm1xftNbq8BEODVPQcFU6pibDgXB0VDivWkuvubbMtUmuv+HGG66fcKPBjV047Lx9Z+YLtLtt
::# Vp85L6bgo+eaeZ7RrynqYPo2pLTYPIGs5rhWAV8s4MYIFtfjdxNjMvtZUUcvPrsYsj5r55ljnDiV
::# V9aT2V+Hf7jyH+n6QD8c+qK7K5wcSY/LcVUaVeJqkPV02LJfWcu6ByqhpMK3Y7I0nojKMUmBCyNh
::# URY1mZa7u2JKRI6noIRD13/s7hqX1XA0rIaD3V2MqeGRFDjHol1iA3JKGYlfYoMiyktMoNaDhuBR
::# Hkkk74HxRDIRTUdU5a6i3oM9CSnS3fXZnwjS3WXWTp39jSDz+f5x+ea1n4aufP/jsM9HO42CVQDk
::# Z+ydI8RMz0GRmo1VZ2e/Wd+DuthrB87ZAhaI0m6erp8/byD+5BLqzbUVrucBK66tc32G6zphv4Br
::# 7XXzpEA1KaKNlod1r7MBGyXnTcUszImiWnubyCryQil8xnr9LlMF7+jMNNDGpXe1eVxoHuWBOmgP
::# xtyocAPur3Mji2ttl4X8SGflzr1ACE7AeV3EYG8eOZWHnrDb0XqbZsYqVszXs+bUS66Vm411rmUB
::# mtYXDJvrWeRrp0eI0cyvW7k8tkLbGNmIRMcEv/KzEIY2pqhSUv5fWknKECF24h4SHqDO5c+fT2Pb
::# FDPm6YyAAJmPKCxDFCG3UamN3Waldath0d+i/fiZlZ3nxrG1dkDttdKCmDEmsUgsnAR0UCy4VhMS
::# gZevLVlPSjaGs+gtksgW0sOgtkr/xo2Mdq7VrQdPHR0KuAX9KFLkxjY2r36If2s1iv85o9KZ2gFx
::# ZrIjlFYKtFUThcebSnmRADfuk8MzVBNc7+JHfYuEAj4Cx0pk8B6znd2wH5etBxln4xGUzp6fth/v
::# Y2BA2rMprq2a86AqWkcALdwggprbbUgB5+wdacmqKzuI1EM4aP9/0TzaxgqTcgpkg6z3QlF7CY6q
::# tVV0yg1zrgadAxyANrBe7iGLRPNg3BuUBuSzgCdhqzrTPJq21jegGsglt+pUOmOaMswGSCOfYvZG
::# TmRGAjtH2LtGF7Fg3h0Zf+0HIWhlVLugp8+Hx9Ez6C5KsrmVA+Z0ILLbPD5G9fe2KtD505o/h0ah
::# jzwVIaHVRSgwpElQ7BAOGepVr4KQdmQ0a3nT3HsC4TTrD8R7IthmLb+0iq+cylMsD5i92sDYTza9
::# 2kTqVuX6MeHxjhslBE+r2UVNwEZhhkIon95k2Jd9/4U/0tCQNDDABgeDQ0P9LCCojP0mgPknnhb3
::# NusZ6N4g6/Mwqoodk12nANya2IWKOfcO2GlOT5nV9/0ulKBqVukJSDnDBgcvrT7Hs8SQftzEdoHN
::# dtd4N+niDwJwtwFowI5kOIcCA/wVLADazU+2CaPVBHHdxid7bmjUZAYYkOxCuC2FxvkCBKOtDcTd
::# HEbj9/vJVFxkregIx5uyNTmHu33OPPRFGe6xdw6I/FnS6PdQAGd7zj6YhI9OCUJ4QYHUSG8XBF/t
::# 6n0rl+kXwJ2t24UVcol597PfMo9ZHzw+5ilwHAqT73frizYjYipikcT4OCwDDMo5yry9AKl4Jopj
::# CKkgNrzkaOk5RQBNddEl1U/PMMhHPMGNZW7s4XsFoALkRpbKtEsHsjhpAZ2gcT3tj/C2hyTQ4xdC
::# AHCtlc6X8mLC4tojl+pYqzbVubGEN1IBvU9S8IL6kfGoX/5FZoEIS6nhpMp6emDcaflrP0/eZu2/
::# FQun45FRPxwm67/Iq2q/PQT1cwnZ4ylK6K9uwle8dp5ZNet1Fvr8p+ErN3+4eePq9e+ufH6rzw+P
::# WToq+2jYLe+Z1dXOIFNjSiyWutU5GYWges52nqSaKO6dBELXYonbIZqkQz5fQDj4YG4MtHMnObNm
::# N7FUyAnIp2MT8f8QGRitmvU8EjEkwpd6JRqLXfcSTscXzs3JijmVFe9/R6QR9RdpzGX0B44uDre4
::# +S92eWBwALOCy63Zl15aunG3Pu2aW/tWYZmo8kzMhVwvcwMwbVhL96FtQejIsiqOiKkFWPp3svkY
::# T9wRx32qn++bCw88kVGXfQNvDW3ANV/xTPFrYU9DICzttWqQ8czMJ39MYDUDE0pkLD0hKpZ7ROUv
::# ex599jHpRn60f3uU8q3n9CHFZh+ukixtB0m46feT+PHUVl/Cz1VYHLlB2Ag2++289bRIbv4AUEsH
::# CBtc5FJhBwAA5Q0AAFBLAwQUAAAAAABKPkddAAAAAAAAAAAAAAAADAAgAGktaGF2ZS1hZGhkL3V4
::# CwABBAAAAAAEAAAAAFVUDQAHLHvFav/VxWose8VqUEsDBBQAAAAAAEo+R10AAAAAAAAAAAAAAAAT
::# ACAAaS1oYXZlLWFkaGQvYWdlbnRzL3V4CwABBAAAAAAEAAAAAFVUDQAHLHvFav/VxWose8VqUEsD
::# BBQACAAIAEo+R10AAAAAAAAAAAAAAAATACAAaS1oYXZlLWFkaGQvTElDRU5TRXV4CwABBAAAAAAE
::# AAAAAFVUDQAHLHvFakLOxWose8VqXVJLj5swEL5Hyn8Y5bQroW21hx56c8BJrAJGxtk0RwJOcEVw
::# hE2j/PvOkOxuWwkJ5vU9ZsiEhtTWpvdmPpvPYne5DfbUBniqn+H16+s3YDc3HmDdDtZ7ainMcMZP
::# 63qwHlozmMMNTkPVB9NEcByMAXeEuq2Gk4kgOKj6G1zM4HHAHUJle9ufoIIaqeYzbA0t4nh3DNdq
::# MNjdQOW9q22FgNC4ejybPlSBCI+2Mx6eQmtgUT4mFs8TS2Oqbj6zPVDxvQZXG1o3BhiMD4OtCSQC
::# 29fd2JCK93Jnz/ZBQePTBtAswo4eTZDUCM6usUd6m8nZZTx01rcRNJawD2PApKfktM2InHxxA3jT
::# oTCEsCh9svupb2oi9RdaanisyVPm2rrzv14sKjqOQ4+kZhpqHK5t4vxl6kAZ6j+6rnNXcle7vrFk
::# yn+nw2ksVgf320x+7lfuXUC5dxV0hsvncR8l31ZdBwfz2Boy446rvy0NpMAH/AFs1cHFDRPl/1Zf
::# JgkbDqVc6R1THEQJhZJvIuEJLFiJ8SKCndAbudWAHYrleg9yBSzfww+RJxHwn4XiZQlSzWciK1LB
::# MSnyON0mIl/DEgdziT+0yIRGVC2BGB9YgpeElnEVbzBkS5EKvY/ms5XQOaGupAIGBVNaxNuUKSi2
::# qpAlRwEJ4uYiXymk4RnP9QvSYg74GwZQbliaEtd8xrZoQJFEiGWxV2K90bCRacIxueSojS1TfudC
::# X3HKRBZBwjK25tOURBi0R313gbDbcMoRI8Mn1kLm5CSWuVYYRmhU6Y/ZnSh5BEyJknayUjJDj7RT
::# HJETCg7m/A5D+4Z/zoItFG9L/oEICWcpgpU0PLl878ar/gFQSwcIiEtutIECAABCBAAAUEsDBBQA
::# CAAIAEo+R10AAAAAAAAAAAAAAAAUACAAaS1oYXZlLWFkaGQvU0tJTEwubWR1eAsAAQQAAAAABAAA
::# AABVVA0AByx7xWpCzsVqLHvFan1ZYZPbthH9fjP3H1ClM7ZnJMVxfGkqf/Ccc+fEE8fO+C5N0k+C
::# SFBEjgRYgDxZ7fS/970FSElnp18SmQSBxe7bt2/3FovF+ZnTrVkpu6j1vVnosi7Pz0oTi2C73nq3
::# Uo9uat0Z5Ye+G3pV+aC0CkaXJqid7Wt1efXD1Uo1eJL+3ddGOfOxV7rgBnPlhnaDxe3Q9HYRe9Op
::# nQ93c2wSe90blf6ri+BjVP0QXJyrOHQd3uPf2m2N6/Foa++xtjOFrWyhetsahQ1si4/xttV3Bue7
::# qO5ttJvGLNUbd+/lIYz68uh+L3jiPirv1OB626hZ7H2n+Eq1vjSz5SO4wEaNXRZ80Cwstip08kcf
::# BnN+1tjCuAjH/fTm9vysNb0uda9X52cKJm/jSs3ol7l6n9x20+8bM1c/B18OcMu97fdz9doHWN9b
::# t53xOxxgtj7s8W13tA7vFozT+dkXp1E6P7uFq3Moah0lEsvxRBuV8736Y4i92gRrKjhEnkaGs1TR
::# K+3kE7zW1uF4x5DRLbZfynlfqJ9NiBYxc4XJB0YcOTQmKt11zV71Xpl7E/aMZufhEUFIL4bhZF/J
::# 74hQJix4HsDvassIIEzYc69KL6/Mx84GYKHqDWFWmV0CBEwtudG0sNEdjtrVxsn+iB8wUdQES8RF
::# K7X3g9LYanBxCLIS60LaA6hpmmT/fNxVLnyLs/ighd1VsnM6Ivs5EjkPAaNw5ZljNJuMIPWdd5UN
::# rYJjcUvVWGfkLIeNejnG08agSlNpZAaMAkJGt/9a6z7FJt9J6Q0SUIwAXLjqNdOhQsCiKgN/5zAg
::# NmpjGr9bcdVXS/Urkg3fqNa0AJcgAHY2S3Xp9ogC3qSgKOS8gX1YgBBufY+oL9VV8reOd8degPGz
::# O4NMxvVai9j8tgRMny3Vj87vuCXXahd3WJuBWPrT5xJ4VQUrLAGT+x1Pn+Fg4G8mEZ+V9B3/hU0Q
::# CQYSt1GlRZTPz75eIq90YAJxAfeudSiJO9JMPsGGOHIROIjZADLb3Fs/kGfoirkcVnomPGzdYevn
::# +PiEYYBF0wBNFr5pl8hutbECbxqUrU2ArRHVOIOntkyclAsRHLtU/9Db4WRLbRucdUEvdxp+NBKd
::# QoeCqxOPKXDBVqiQXIF0XKpXA/K5TGyX82E8bQTQB6Zo+v2FAgje/hk9jzSS3NSMNngwWj0GLAed
::# BIFEUe9wXuFdj03SP7TqGu2Su9OuYsYrXYLK3pr+EWNj3V0GMVN/qX4n+PUAiyqAVfgr+a/19zy4
::# s6ZAlJcE1vfec6sPg1Nr1zGpwOBI4T+idzuz6UHzbp3Ty5SIyzqG4ktuvuzj6vmzNTc5P3tTPcCl
::# xj3aFrGbq0739Zx5HJ3tOtPPATu19YwSPbMkdYNxsJ7JSH7CikohTZlLo6eRAe8+qXY9kicenS8Q
::# 7lGvEFIPSPdIcSEJrp6rXbAsh7lsIs6N5fnXuqhlhUrEqeBLV+J19jgikV4zNJrQmGXSdDPV71Cu
::# xMpfohEj4OkxTxgd3WdWpHFgL4RJu33a8AgCJR1CvDljypQ2lW9wChjIgvzSdtaBH/iVmGmQMYDz
::# JQqPD704Gj51NtYwfmN0n+PQNQb3ltd6g53xcXmEo9cCUN9lOq4s62ll0xVVNbisNuJOd4wdkDYS
::# 7pCLBC4cExIEUOdn6/VaKPI9dz3GzFrI7IMBrguj1mBWW+1vBWbqMZMkqufPyIIX3z45pFWGTqJf
::# oacJsTxbLRYC+CVFTDpEDEjQweprl3OUfkMYwcf9J8kKEOmRuIGExlTJK6itIBn1/t21+pPMJVkT
::# MqCknSdtDz2L5fU9affEsTOcDmkUj9z/AxYknNSm6SIZpUdJUXfgSyYC6+1Ou55OKe0WZc10oKND
::# 8r7DNVYSi8khawFQp4GafDRDTFak/XRzihbdA0K+eagJR3dAXsBbJdwRya8fkS9xnjF22DijAZV9
::# JOX0lRBPNJ0OlKH/GsjPJwz2A7LwUcwbfQT97lMaa6iHXMLhvBIaSaqrbiIzUROfvJ8s+XB9efXT
::# taTuIGUDajG9P2G4h0fdZLMaiMJe6t94gE5HHJ2NSk//t1RDoFNXNjlgBNBLceTldL30JrHZ0AEM
::# 5UJoKRdrPfp4NbFlLxeJpqnGcItgnBggKT4qGetEgdmRUsgV8QiOVPehYmIxTaEs56RRvsdNJiq9
::# YP4dNwhJ31A7PZC+sIM21zRjtjMi+yhnyF1f09cXs0le4L5Ri0YcN89aN4X6ShTpB+y7n3Ss5B/C
::# ID7Mcbo57K1IVCtUbchGDV8ysCXYWOC+0cVdRR+kjXbweDO0LhGDYFD6rJfH5QkSxhHlqSKyeLAs
::# scIisB5iZYjiOdr3oKdaqaSXIGA7alWpJ/LIHWSElvDaNklvCExT3LHEJHIflbumqnoxyguBnNNB
::# UiTxLS4lNsHKjqVxCtw3S/X9/2nVuOyzQki9QiWFn+9o7cR+UFwnPHTLvmEnLmXHR6GSatYhOJei
::# Mr66GCmOeBXuxzWChLbw98IB1CGXLpVz59n4VLzugXX+tlQ/8ZixPJWpeOcWk6tuavDfTtKMP/AW
::# 1HN8AWzdxklHbwZgWIQb1rCPLnR3dLs3j+C4FqhOFxvFfy6nk1qC1a0HRfrc0yBUp0rprd9i/8mi
::# VFVavUU0QKt3sOeWfaYwMSm5NPfQT1ID1l82/Hh9cMK3dAKl58JXC3YcsMelPs+E4IOE9B3TU6A5
::# +wUFrJ7P1Ox9DRPmqTu6FfaKxrRynQ0VDnADL7bLGWU8XFVofi+UAvI7eCVtONVw6VBSkRAIP9zX
::# pUJw4pBbkyuL4H99XIapD1fsPE3BAD97+nSu2IQ8fwpl8B1NWgFJ6F/hcIlALbSzVK/tR9BjWar1
::# JR77YP+dJwSvDCgoqL/+R4Tpf9dj/IIR+j149u88oBOBJ9ZfSO6KP1/DaY2XMsiXdizODiprbLVh
::# Z/Bg72Aakk76WPwXtEv9Wusjm4PG3LM2ZCn7o8mqLuNYQMLrRdR06YhwL9tKhJ0/EqkV8zqdQn6R
::# 01F2WFZlUTYgmOlITnmoRlNXDWGIRMP+e0Ek07S07HfKLFjQWV3ZCF7Z5zb8pAVHKAI70UhEjU/3
::# iDnr2IGrkxVwJ2JDxlse8Olbe+SOtFA2GhPcnTRaQjbSUcvQhExnIqqixFmMe0Emlq5SphKW+2vc
::# cB8tu0sAoSBywdu5OuIp6lVpWSYUKqwJOulWXCm5ioF0lYyGRh0iTdxTkfiwQLcbagtERuhDfhWN
::# F4DiEjribmgQRxhtbFlS93Q8jIOp77FFPykBJmrSckyYOTkIDU36eTME8xf+eOu9AEQnFZBf3/pR
::# HYjGmaTTMiH8cLbYGaexzoFNWd1G2iNbSb//21z9nqTTP9EN1RZ9T2tw0Kf78tbpTp9Ro5QdB6ls
::# GuTLbNKxiKvoWHmku04GWUWjqfP57DW7/SoYEVMwMp0s04aD3h8HGaLbR5Aeukte5jDQMTLy2cD3
::# eZIydujvAcxgywTgPA1KqBwnOL9MuOfcBUzVACaJVne6uRPJVyMXtzWo9Dq9lgq954BEJNgxcOL4
::# KLlvjqKU5NfGlxwgcdwWE/noeDReEx2H0gPGSxTIOcHDNiPegTgoe5bSQl0BEkEmmeNoQGl+rB6v
::# Q6sWoULZAdahBbshIlOyjGrtdsyLMviuE+wBLbD/yWG2llpL2Zel4EZXps/VVQo8nM0BapoUXZnN
::# AIbrbNCN6FMa3qD3oO8YZ5kzcryKfdkRJTdtAjkckJCRHxgjiDKiwCx8CQ31Tmfu0Sg6bXcQ17hD
::# LcOmXfA075JCDvAurd460DI8etRsPBfZ2SjEyG4HWD1S/lg01HtOCKSFzjilGZOeT400ZFUuVCwC
::# hqMEukZmTJeJySqalcNKYCdo6vRy5weI6NJIK36M5p7Cfz59JU5+kRSs/HVAJurIhI+aqY2EFEnE
::# StDuQT00Mc7AdzhZ+ubnUqKQoPnd1PcuZATVBwAKcqOKLCAc0qA1SKybe7k0s0zzgiRkx510ODYd
::# d//mc3fPKpt/JYhMPipZNjzji3TXuI8ipgMYS0YKtDom/gDSpVCi+RjQxBCfpPmCg6mJDUYxzyja
::# QC0K20t/mANxlMV8QCsBvzJ0s93UxgF2nbdsqk9nkXDtrvZS0cxHU4jIFXM5fmEitBwbWldYBINJ
::# fCHtI0Up0lFzRwZw/kkAx6l/MAvUuTI1ByLEUqrxIWycZ4iMBHUYILI68o8FJGEphck5MUnkcSif
::# 54A+zd2fpQ0kFx9+T9KbnZD4y1kqlVJRZFf5EwcuwQJXpmS/dHs120x9OrIXMd7okBKNb2tTbiVR
::# SnhxQ6mQJuHHtVc9nkHmYGcpE5LP/FFIknQ+UjztZ0+yoNKyZ+65oWlYgsmMnBoXJrC099AL4jkZ
::# 3iDI2g0U1AORUZDV2MmbnK+w0pbWt7wvkDuQecBOXR00ZPLjWWFDwWE/yJZmIbkSixOAwTfUx3zu
::# 3TSCRrZsDQ0eJ1tTKWuE2Zrj8e0tMZwmXytpoQ5Ez//F8e84J7PjPHJMwUx/9Eho36fa/Fg/SUGT
::# 4IteS6X+8ebJZ6L5MvfFeyNqSsYD/wNQSwcIKls4JWANAAC1HAAAUEsDBBQACAAIAEo+R10AAAAA
::# AAAAAAAAAAAXACAAaS1oYXZlLWFkaGQvVVBTVFJFQU0ubWR1eAsAAQQAAAAABAAAAABVVA0AByx7
::# xWpCzsVqLHvFao2PwUoDMRCG7wt5hx/20oLZoB5svUkpUmi9qCcRkt1NN0N3NyGZCnvzIXxCn8TU
::# gxR68fjN/Mx8f4nXkDhaM4hCFDuK0Uf4Pd7M1LlIiqQzH1aa1rXvM8cc0r1SHbE71lXjB3UZm0On
::# A/V9Oh9qGEbOD8RY3C4Xdzd7zHabF2ypsWOyV3kZpkidYzxM/ljjMZ9NCd+fX0jWQm83q/XT81rP
::# q5NoWWbv1jCN3Qm11rVJThTZDE3vRwspWxvY4Rr/sobiIShyRhRNgIx/rC7LqArn9PteFD9QSwcI
::# t3S3jNYAAABKAQAAUEsDBBQACAAIAEo+R10AAAAAAAAAAAAAAAAeACAAaS1oYXZlLWFkaGQvYWdl
::# bnRzL2dlbWluaS50b21sdXgLAAEEAAAAAAQAAAAAVVQNAAcse8VqQs7Faix7xWplVV1v3DYQfDfg
::# /7BQHmoDd3LT1P24Qx/apPkA3Bao8wcoiZLYo0iWS95ZCNLf3llKZ7spYNiWRM3Ozs6OXtA7PRln
::# 6PXdB2ozJz9R66dJuY56H8lsR3XUW9WNXX158YI+OE7K2h0OhZmSp39u6qEg3Kyv8c3zd4BnN5RG
::# 7SjNQdPNl4D32vbb1rukjNMdsSeT6OTjgUnhhwbrG2WfOEUQVG6mzkTdJh9noFxedJrbaEIy3tFP
::# VP385v2bbR+Ndp2dyecUctqRauX5tjeR04ZcnhodpWTSgXHtKUStpsZqQuOt9awj15XAB1QNSZAr
::# XL/FY3REUXMi3+N/w8SaGegb4lGhT33UcZYTwTvWRUqFS9XpSCeTRhKKNX0EzEKPgOF8or8wA2pA
::# vd+LEoIsgEUZ5cpreAyxqMUlWiK0bFJR4WVNdyixFBCGTj+kte2lVumdLKQWZHWWdUNBpXEjfbMz
::# Iei0Nlj4SqGY3abwk1EBdblQFKxyqP1NTb8XPWnKNpmtaFqmWNMfqNX47Dr0sFChgHNyYi+iL0cL
::# 45OnSoYsdqkYsK9q+tWt/XjgoHgbdfpPY18y7eAgR1IvFkR4MyctaN/WdJ8DhsxMSblBu8Q1vYV3
::# eZGrzTHiJqThvGq1x+gsxBeX4kVvj2jj74zJozSjElZAXlWOTzpi+jn2qtXoyli79QG+B3HGL9xU
::# i6xwJdjc1vQnYFSSw/J7sUzK0dFVdS+qvBJ33aIjp3fE7agnRTl0ONxBb0iwo0a1hx6lFv7e5snV
::# 1TXgv6vpnTlqSmYCNOhMeE0IP4mYnUlMV6tAGxp9jnyNyQoTTIIakyrxRMUeIDLOCsjf1/SbOki1
::# KVjgdOUJHQ0b2Z3nFZKOEypUd37A7WWryzAnNZhWfHjABD7GeUcuTGIy6vSx8P8Bw1pkidFHxhsJ
::# aFvfb6FvsnijVZn1mi29eYAisE+GUcaFNB5EaKs1KGBKjRa7Rg+Ok7TxY02vVQAHTuX5LbYIR3cU
::# lTvAUFZkXu5RI6ts9VFhijI2CStSXWfEBUin5RTMoCMuETnSJPYaKcWtip1xg/Cc9nIDKzOXK5hC
::# jgp/xQcUA+tyhYcz+Lai+uMaLzVAFHXFwuIAmZOfEBMru/OpgnKejxO/L/Lxfg0riRSWvGP4XZU1
::# EjLrVqOHmXFM4kCr2I6Q6+XXReBzRJa8RAKrUP6TtJQmUVAxeCC/uAwwpqc0WnZkL/5fGC75JvYu
::# 8fULsA9yEoEZsy1bswq0e77lEItp9lnEqPQD9DRuGflJWQGIPg8wwdXg5RtiPYjhryAkH+A7p3UH
::# v5cdfZ77N0voX+/hFHxRUsxIGOzQGjSSmKPk6xUMjnSYzhHBqtdJJqZgpSbqo0kzQISiimUjBK/J
::# A3EwEX65cmodrULUTGHNMeTDZIYxiVdPEbQ30mtJvs6owXkwbh/TBxUeP0TlnhBEqGWkO2RDR2bI
::# PmP/ziA8esyjtSqafpZx/R9qVFH88hW0PzniGek80fr5kzL46sI+MCZ8tJj6cVgNwvfqGQYG72C4
::# g0aSye1iuusy6U+fVBz48+fLi/JB/RdQSwcIO5WuK5UEAACFCAAAUEsDBBQACAAIAEo+R10AAAAA
::# AAAAAAAAAAAeACAAaS1oYXZlLWFkaGQvYWdlbnRzL29wZW5haS55YW1sdXgLAAEEAAAAAAQAAAAA
::# VVQNAAcse8VqQs7Faix7xWpNjzEOwjAMRfdKvYNVsZYDsFVigAMwR1biqBZpHMUu0NuTloXNst/z
::# tzkb1YieLn0HEFhLws1lXOgCwx1u+CKYrrfrsI91lmoukPrKxVhyYya/F2PkqgayWlkNotRDgkoY
::# qOohB4q4JnOlylKsmQ8lOPE4t4gRwxzABBZ8EtjM2lQtkhuC/wGYAxDqtrP0Ib8andv2viuS2G/H
::# E5iSvB0vpXXYHOeXePxdGzEp9d0XUEsHCBXSQmOvAAAA9QAAAFBLAwQUAAAAAABKPkddAAAAAAAA
::# AAAAAAAACgAgAG92ZXJuaWdodC91eAsAAQQAAAAABAAAAABVVA0AByx7xWr/1cVqLHvFalBLAwQU
::# AAgACABKPkddAAAAAAAAAAAAAAAAEgAgAG92ZXJuaWdodC9TS0lMTC5tZHV4CwABBAAAAAAEAAAA
::# AFVUDQAHLHvFakLOxWose8VqjVdbUyJZEn43wv9Q0bMbs8u2Oj2z09trbGxER0zHRD/0PMzlvR2p
::# UWIVOhR7o9/qAgoCDV4RwUEUBbEFvLSNoPhf5nCqiqf+C5uZ5xSgPRu7L0RRVSdPnu/78suskZGR
::# 4SH/xKw6rgReq3N+39R0cHjIq85PzvleBX0B/7jyeaeR4LmylTG6m2vMWLXiS7y6zfQ00w+dpQpv
::# xzo3OevghOkbTM8yI8Y0g6dCzGgx02TGB2aWmHnO9KpVjTHjlhlXzKhhnPQeP9mC+532Tnf3mpkt
::# K3rrVBJ2LcSzZ0wvdbUzZuhM07mes0727gc0VvliorsZw0zgnXCZV+Od5iJvx5le42u6c17hqZVO
::# YxkjH+Ud88aKFfj1e1iIaUcWYQvnEJYXmb4CZ+HVvLMfhlDigOK8FO2Y757ylWWmZ8TpnvtfB/6l
::# Kv/2BaeVsR5syj/Ekn8qf+q0Y+ODT55MPxz8+/cvZv8MYT4fHpqYm1qYVf3BkWmfPziuPJAhFArw
::# BKLju/D7WIZ+ANz45id+nlFHZgNedWbEB6lMTgiignML6vDQjG9S9c8Dny+e/zg8NKsGJ7wTwYnx
::# 4SFFCU5MzcMmTxeCAX9g9s1D5Sf/RDCo+r2q96Hyw+S06l2Y8fmnHuC7EFSdCsy9gfdfzQW8C5NB
::# 32tf8A08G0HJDA99NiiY4SFmHjLzmhmX+KvXmA5SAeiA8aji8fzh6fff/vTi2Xc//uDxKEJPH68j
::# vH7KaztMrzD96ON1FIDGayGg6w1ro870uH3UpJtR5YnEhullpt/Sqgy8Sbl8pgBpdrFJmQxu3d8Y
::# 1lVRwJreaR10GjEpg3bM3g7Bzk4BliziWggvoj4aVf4fHUNEj8fdtA2i+lTScKenao9ncFupcTrz
::# 8NCXsGPkyF4v82QN9EoHv0BAzWOnfIJVZ7ZQmrm8vdeEuIAhPKIX0qASSumUGQ1mHohVdFOmKmpg
::# AO1Sv7SwmPNWriJK6L9XWsbN9KtRhRBLOEd1OvU+BADAeQpublmbV9b5Bqyzr+rMWHZu18kctnHD
::# yAGg4ZT2rdOmfE1v8MgSvGZlgdWIu8NfR5W7mqry8AFfzvJ2mOmFnla6u2E7WwXFdW537I0MMyt4
::# WjOCVRs+QE6Q8E3kRLiUsXoX869Hle5SwjnUIR4vRnl8E5UpcDABh01mnhAaNQS/eGptpPEicdrN
::# NFEMxZydPyA8d8FHuto2/O0B1dVS1ruCax81whnwD9HOj2HnzRgvxUDYkK7yEgpVVf7yx/mXimAJ
::# PdB9gUdayENyk7fT0nvLW934mXA/14GrPN4UYDJ9nQrl2H4f7+pve+4thNNPkOL/XrHExUIhDXhq
::# bdbpOtTDERcCjkQrFBTkgwmIs8LTpabI035vIJbujjITPd65yZBsDplhWGk4bNLFSYKE6tbiYOw9
::# CfcdXoMjNIhIDbFHOP82CkYDpdHNpHg0gQKBZVgFKGBIArVFcaFaNQMjt8NQE53GCUUrW9kGMgON
::# 4DZnn6z3F0Ha6Alw0h3yh9InlhCnGmrLA1IKrhWAakKiFhGTFdDxuX25LTqOy5qLTO4dv1mjxEO0
::# KXmRHqesk/QrqwySeTk/o6qvlMdfDIiFSoMQJT7vMQ81fI/8ni7dlOPWzkFv+SOe/VWImqgc8Nrf
::# pQSf3XFGTBwYvqLWSuVEUiVgdnsqwCUyZzw0373gqQjCpul2sm0vX4pksNLWr/hm6H90775DQSPQ
::# 4mKNDQkhRmkiuuRq4ZAqMkTrZVEijsYaOcs5sUZNCfRJcUCxPFenVYak7F0BM4uCDWFC/BYy2OZa
::# xtnPuSWQ6XcTkOf+Nk+AzNIezzjYWxq9BezaKJG9RPhimHwO4L0h57siC1qUlobXUWackL0XUHlw
::# E/CogIZu7eyFu9mXuBUzdYwrnavniiXnfd3Kt7BjIRvO0Rlozq4uWVENMxapD5goVUVCnAQK0spp
::# nZu3X3dal1B2NFQoI3CQFDPqkB529vAHIHBc4XumvRHnWhGJPGoK70b6DUD1pJsp2lXc/7uAXx3z
::# L8zMYGv4NYY23Uh0GpqzdIGu0o7xInq3lSyQpwHZIIh0b1+JDKxxLs/HFehgfbSw3e/hEAFuHVnk
::# Zym4sDfqvNGwz1t4081QRhMjI2QOaZirEl1N9wYm54NzMBbRkImnAMt3ytd0ljIzj0gnBQK6RaQ1
::# 4BG2lOJSX0WwduWGpxK9zO/zOK58/+zpNy+e4Zhi5aJ2qEC2Dh0xBG2S+n4eOq5smQOqcJtoFfzX
::# uY7KDQYHXsCFRm13AMB6ghqyQ5fI76lBzTCKrdKICSTFm0A3zaETXu+Y1/daoYom4YuBbH7h57HZ
::# hZmPuCnMAzxU4eEIFAJNJagI5bfF1T5J9E+ALB/cx4BuD2YuhsJO4xBtBJvMsrQm0B/2Hb3I60ka
::# LZJu/ZPFuFuOMXONBiScdiRt1JNEGKpe2UXcmUNWgB7ndYAqIXsfFfgjhAvaMNkVuKmopAH77vv+
::# wNwjSnJEcvBpzeNsmK3iNGi2nMOkfRESyaHwiRJeBKNLWmXItQJToFOOwJhiYbXXcAQzkqIDW8mU
::# VYhQx8ATut5+7CCG2b4ron9Xo+AxhGaVRy5hS6BMfspBNzQM6WNV7H1ErzwAAiAH2g0ad/NyrAUT
::# ugyLXmmDg+8vi/PAGbpmGb7CwGOttQT0O9LGEpXJLY8ugw9A6r8E5iZV5dXC/DTV2DscNZHFO0XV
::# Bf5vC1R1H4hdGM+gOYE7VZlRpC4vTJJ6LThb5ay7tGJnmvZ6nnRUExWEYOjbclrst4sRxS5t8dqi
::# ZYYBOmHe6FhQaVjEeUwFyRoc4AATqakSSaWCzFGP7jHkjg1VK13GoC4r1tZbmpcyd4gRoxKNg3KQ
::# ArwGpjJos5IO+Q2jV7+iiQ+bj10vWDfrn36twjeMOyTDjPmLb0Ydh688FeYGHDP6Z3v+DX6Uf2gN
::# zOCya4n23WnisA3fb79p60rnZgNrJIalx4wIfTod90cUPSa70OBEIJeCSds7GpQUYNvV1lFxSCGe
::# GRsMdVToAPgC+n3C9RePR5Bmpxbt9VMZbPAT4c73gfvp1fsrR3cA9m2eZ3eHh/4DUEsHCBrCdc0G
::# CQAA+xAAAFBLAwQUAAAAAABKPkddAAAAAAAAAAAAAAAADwAgAG92ZXJuaWdodC1nb2FsL3V4CwAB
::# BAAAAAAEAAAAAFVUDQAHLHvFav/VxWose8VqUEsDBBQACAAIAEo+R10AAAAAAAAAAAAAAAAXACAA
::# b3Zlcm5pZ2h0LWdvYWwvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AByx7xWpCzsVqLHvFan1X
::# 31MiVxZ+p4r/4dZkt7JhgzNmdrNZaytVqdqt1DxkHzbJ09ZWSbSjVBQswUnmje4GBYHxJyiCQWdU
::# UCLo6DgIKv/LXm43POVf2HPO7W5anM0LBd33nnvud77zfQe/3+/1hAKzyhgLP1fmQ8Gp6ah/KhyY
::# 8XomlcjEfHAuGgyHxtiHRkHr5ze4WuFqg6snXF3h2iXXb7he+/UmKeqZbmvR2N3vtq9+vUlxbd3I
::# LIn6Dle3uHrUWzoRd+nubck4POVqjqtFrqXZY+dAxtW6E81MJXlMM7ZeidNteN692+3vwfO2ker0
::# TrJmIy6KbzCNmOpsgWXuBPD0g1KvegPLjFaMq2WuFrh6Bz+tHLR18wpyW4MgfXXTSK7C7WhBGW+n
::# 57l+ynWdaw16XhN752JtGYNoacjtWeh5+AeF/RiMTrsuQaixvzlJfc7+0L1Ljz1YIRJVri9y7Zrr
::# SUikH4NECh9B2A+9nsD81MKsEor6p4Oh6Bh7NIjGKNZ797LHLBqI/BAZmZ1k8BDW9PWqxIP9u9tc
::# 7hdW2WfT//n8EZQ0GAl8N6P4Z8OTyow/CPeYCMj6RucXFK9nJjihhCLAha+efeP1zCrRwGQgGhjz
::# ehgcMRWBjL5YiIZD4dkXH7NvQ4FoVAlNKpMfsy/hYo9wFYRTpsLzL2Dl3Hx4cmEiGnwejL6Ad34k
::# mtfzwQOaeT1cP8JLalf4ieza4FqGq2mupbrNrChVoQRIOQLfVfQG8/l+98W/vvz2q3/885uvfT54
::# 6/WIm5yRO+Nqxjxu0abUfaY0eCwjVuNca1OF33G9wvULYJBRhwM7iK3WABiJMtdAXomkXfwsVyGd
::# DnVA4d6BNTbugD0ONRmfDfzE/vpkdpzR4mM8wuohuJxGVzzD3NRd/A6Fq6egdjIGnWLRjbavyfX2
::# 2wb7zAqGKQCsH7B+Pi0qaXiKv0dH2DiUTmF//H1kkEDFWSOSbTxxJS/utqwerW73M2+cQ72eT0bY
::# ADZtHbCWTSVWGj39FkK6W87ng0NqRrHJ1ayxUuRqcigkaAQxGNAfD83NsqgSiWJiGab8FIyyJ4gs
::# vLKJjK/qRumE61C7iuzF/l7CLNZhCy5GkcEsGWN+ZhTzxjYI0wkSP7lIRVZtGt2RZlk6IhYTog7d
::# A8WH2AB8EzsJvqv13tGKeRmXtDNKMa5p4uhQ3EK5TnqV1/0lajgVLnhhFQ222M9tgagZ2y/h1oPS
::# 3WN2rXdxInIrEm/j9BXmBvTE4sTpMk9H2LCODeSrzDWVdPItCpSLqcYlxIuLJaB7AWB2XhnHZSrU
::# gG2jEsJREpBFRFWHrRWz0IY62YgSmUC9zYOWxaSHRwIC0G7vA9gRanjiaLXPJx3A3AF8a6N4NRWU
::# 66Afe4OXGhCOGvPeYeIug91vi95jrm8gH/UUarsl8luQzhBuYjHrpo6L1ohx8tjcrDo8dljeq56i
::# Zelt+DRKZfNVC+6BiOKBsGALupqyOifeHFrKjA+HIMd2QzzJpoRaomID1GWgtKUnQ/pDKUN7ujL9
::# 0wjr7cPts73jM0L5NZEgJVbh4baRvzYucuhk12dcW+51NslZd/DA5KEkp3HespapTZFcgmVGsYO9
::# SSfIOOLg3MhBapmnovgzuWJcHuOw/GH5u51dM1fAtpFOpDbNStvWwz8DYe7Rvi4Sh2K5KO4SXN13
::# pNzu5saDYDVYj8SKqd12Holle/Z9unw6wvpL2d6RilJ0kBKZPJHfqqW0dWr0gZtjaeV14Uv2vF9o
::# ococlMzyIVVrD3QWPBV+OmXox1aNX/bt/m5QFZ1+/csIqOLQkSKVxTsCWvgQC2u+1UgPcRuZFDrQ
::# XQK40m2eSkch4Yyj2XRK5unmYBPkAE5gVYKmr2HfythCQiW1MM6ITkIiA4Vk45EZRZljnz5xOQGt
::# BEIdScH7//1CcgDZuMa7JOW6I016FPoYNYRWWL0o0dLWR4FSElVbnVIY0A+oSbB8vrFhxXN898EI
::# h/2DFZEwky70Ordiec8eLAfVwYl0Q0W5XV0Dy0S/HB/MYWQu4vZapBzRw5TcTMHEaCBYfk8DoKJa
::# ST4kL4ntMg6WFltT5O7O9Jtx8QdPlY4ukmdwLzxVWrRVlXsTQcZ8m+mrLx0gjPwZfY87DYIb0SR2
::# hgZWq4pOOLx+8grcDnCyZnNgIhheJ4Gb60kybKtWMImjsVminqOqly1p19Z7VwnJU3PvUrxeRoXH
::# JsujE6+uQeWNjSzkRyq6RKLQESm4zwEg9H14fkJhcwuRaSRN4heUP6C6vk81aNPqZh9koLNPM9w7
::# 27eAUU2qywF1GCEv55SY2jt5019aMwstc7NMTd0Q9TLpKEwlO1a9BsD42bBkQFzLa2vuWVvcnFvi
::# Aw5XKkP/iNgB8lVfoe1Q5gvri4wOyySDYQ3y5tT2W3qLzVx9ICh+Zla2RWPR0BNQQjx1qQXSiTKG
::# 0csUIjm8x+kU8Ap6kZZeAapoFC/taQil3Niq/sa0cr/Z8Z9PXS6lOQAwJMGumW9XjZ+xohIw9D9X
::# 58BPN6WpBFXJXGtihYmF5kTIyvoXBn3UPuw2Ie36U5Fp0QhXMc/2jdvNh/++YEawvQNG7u+DM8rY
::# TDCkQFNrcTdKz/6OJ71rO35nTTM+n1Scbgs9CAbX/8Y2Wfc2h6qZztH/WkB40TIqabpqeug/rvQN
::# QF2CQRqYpZb5BE9w/5ewTgDnN3djRgqJ0Y9tYsMhgxFkiA0eg07XpAWDYE8xmOSsubpobp5bwdwG
::# e89d7enL+Wnbe128LIviHjFhmW544f77LCdZr+d/UEsHCPUO7A0kCAAADxAAAFBLAwQUAAAAAABK
::# PkddAAAAAAAAAAAAAAAABwAgAHBpY2t1cC91eAsAAQQAAAAABAAAAABVVA0AByx7xWr/1cVqLHvF
::# alBLAwQUAAgACABKPkddAAAAAAAAAAAAAAAADwAgAHBpY2t1cC9TS0lMTC5tZHV4CwABBAAAAAAE
::# AAAAAFVUDQAHLHvFakLOxWose8VqjVZdTxNZGL5v0v9wopuYNBYW3b1pNiZG112zEY26V8akFQaY
::# CC1hpm68mzPTQlvKAiIgtshXaaFIAXVZpFB+zJkz0175F/Z9z5kpZfXCm36cOe/X8z7v8044HA4G
::# 4rERJUJG1b7nydFgoF/R+sbUUV1NxCPkin206yzsMrrI6Ip9WnQ2d5n5io9PtRYmGV1i5iQzzEFV
::# J4zW3Nyhk55kVv3x/dv34cuuzzuVN/CA6DHtudY10g+HbuETz07BIV894LM5RieZmWVGntFtRucY
::# rTi764w2GN2AgPjUmMKAjW2etjALg7rTDV7c4sV9OHdXILVpt3QsEiz73qhTrPJa3j4eZ+YZMz8z
::# cw/zO3zLKHrDQGZeRKnAud1Ybq2eQG5O9qxZxdzcvRQvfICn/yv0bvxF4rlC/lL1IdIt8SJPmPWK
::# WR+ZlXkKN64EA7GxweSIEtfDQ2pcj5BLT+x63UlNR4jvbFFUlmqnxmcgKfi7yyzIYk98Zp9egk6o
::# WuzZsBIeSfQrw2EVgvfFZFv0saQSDAyrfUpcg9bdu/s4GBhR9Fh/TI9FggECiA9qEPuhokEuV8mt
::# RFxX40lVf3mVPBhL9Cf7dPUF/LuEd8GpMpgYewn3Ry8+CyM7goHLbW4EA9/DhzYiERIK/XDz4W9/
::# 3vu19/GjUOjLScbdhl5VoUs8vWWfzsmO8UxJOEX7LydZEfMy6ekinb32OSAvZZhVRqTMQ/ykO82P
::# VT4/LZ8Kgu00J6o8Mw5NbFbPGP187tp5vwY9drKQcF7Ez4F3+6jcXMtLGrnrx4IHXjl89w0kIR5V
::# Rd9MMGd0r7VRYHQfrxkm+g0TweCaffK2uX2AFD/YdHY/MboFjGx3+8vJNLMWmbUNEDnbK03rFJPx
::# +dpaTbuFGvqK4lRpekxPaiSsPYuCD3E0nBgk4XAirgyrcYWEe35sP4HL2hAZVjU9KkeAmdCEFWZZ
::# 0Ar+b02gUXPKZrNMRQScU5jKKOmG3zcf/fHI/6ONKn1adyjU7Q9ulIjat2WqzIJyKujX3JMJQz+i
::# YfKEPI0KjMF311As3p8YGOj+/Wbv7ft37qATuMUzmw9uQU9ItNu7gK7zTs2bC34yDzPqHi4x+jez
::# 1pi1jnyippjXfado8FSVpzOiq8A8wwvXVhXwm3ihjMXVwSE9SnyNkanvCD/QURGuLQwgMEbePlt2
::# 55fcmXH39QGcoE9eOnDmF31hSaGlNY42FnCvzqw5Zu3AoCIVO/Pbn0Z2IPLvxBBkIVdJKI9+5wMh
::# Ks9P8Bro0rzwIAOhK6QMXRa/d1oL6/aZ6fFRsg/GwQPCI6k3M9cuzkyHPi6J6a1v2kcA9SqjsyiE
::# GAQp21rFQeETx5LNgKV7WkOxpHtO4QiHRFJfxolGo8GAnPkI+cVXUzHInULgI0x67PrhjWCgnRgY
::# 9RI4Ay0h9/CH5D4wDwFsYMnuPwDptL8FIMUtcCDalgPrr+VdWJYqP4MzKEpiA0WBkews5tkhGDy9
::# yXOFtuTzRprRNYErotvZUmjaDa9iAfD1LoJ9QQGA9dHoLNjTACPvHRqoQgK+FFSBIAgOArVn3GVD
::# 6I8vmGBTgdqocAoXQKpWhD3Izl6TvrvYAeC7Zy+4aWZEBJQkr6HftdxqHbtR8MEw5SNeWmhDgULy
::# LYhwD69+4hs5920KnINJy9riM7PoBzRibgp2A457NtdaKsGFgcRYn0JGk9oQ3k6/R3ysesug9hkM
::# eb1Z/dCamAWsRQ3eNEoAeeGd3Pu8tuIrdAcSCCuShWYQSvpaQLbjlIrNrROxJbyRFbLbHtmsdOlt
::# gm+8LBy1jA8gL16QC7uC5t2VgltonCsDLcuO4zyar5yDY+wkvIdgGzBVDkjNZHyUKTeWmhtFuHmN
::# GcXrkL+Th5bDW0m5R6wwvNa5zs6n+6cuwvPHPDMh8qi036LEaPvLGF+gMP6kgGJKskJWyk/Xccw9
::# VezwDas2FJIghEIRGMkcwP71DKLMD6jDSgR3Dwg3vrWcr5i7txktQUShc9fQoxxY9Pg1xuBLJmUf
::# SS63Ta+jqaSAMJX1+CIsNToY+A9QSwcItg3kiQIGAAC6CgAAUEsDBBQAAAAAAEo+R10AAAAAAAAA
::# AAAAAAALACAAcHJpb3JpdGllcy91eAsAAQQAAAAABAAAAABVVA0AByx7xWr/1cVqLHvFalBLAwQU
::# AAgACABKPkddAAAAAAAAAAAAAAAAEwAgAHByaW9yaXRpZXMvU0tJTEwubWR1eAsAAQQAAAAABAAA
::# AABVVA0AByx7xWpCzsVqLHvFapVWa08aWRj+TsJ/OGk3aUIWKbb9QhqTJt3uNptesnU/NU2G6lQn
::# RTAydtONHzgziiCw2nqvWu+gsEJNb1RQ/0vPXOBT/0Lf95xhQNvs5YMjc+Y9z3t73uccv9/v9UTD
::# Q3KIDI8osRFFVeS419Mvx/tGlGFViUVD5BLTTpn2iWkVo5po5AtMe2mOF82JlHmUb24kGS01Nvfs
::# nSNGl5mWYXSD0ReMlpn2lumvmQ7PNEtoRv1VY/+Q6TUXzdpfb+jHsDKgqPDsvXfzHvwzavNWYQn2
::# EzUcfxrvGuqHRXvlnZnOwaK5cWi+mGI0w7S0tVo0y1njKOkiQmTNFXilLEHPhWhU84x+YjTfyEOI
::# KxgoxHS8au0eMFoxCxncRYuMjsP67eiz2FOZ/KGogyTQrgt5aL9/zbSpxkmdUXB5wPQ60yv8mSZj
::# JByJPILdl7ye8MjA6JAcVf2DSlQNkQsPjVrNGp8OkX8CCCAAYbRgTuwZtQ+iqI8uQDeUePhxRPYP
::# xfrliF+B4PrCojXqyKjs9USUPjkahxbeud3r9QzJarg/rIZDXg+BGg7EwX8vlvJHct9J5U++Hd9j
::# /aN9qvJMUZ9fQHPAlQdiI89hy/DZb34kitdz8QxNvJ7/R42EZtbnrfk3IeLz/XDjt59/v/PT3d4H
::# Ph8i+XyMzp6nDa209nNSJTSmzzNtk2k7TC/ZH/ew28goMF5nus70VCfBGK0CoL2WsNLQcwzRTE0y
::# uuj22ecjjeKptV6z5/bAslEELpya0wvQorNhcO/aS+P4lNEkbOSluEiCXeQ73NMy+Nn6exMguecs
::# 5+sUAlTzjc0sDyFvbx01irl2ZQ6WzNW9dnSahsWgleb2CqNv0Ey49RNRJ2eeYCQOd62Dd4zuAend
::# aL7Up5m+yPR9yMCZMwimNTDNjQl7pYxYEsweiathdTRO/PHHEmDwpUhsgPj9sagcUaIy8Qcvu1/A
::# OD5IIkpclb7UUwB5rvqwQoZHwQRjFPMFqbRbIlLMAwsYTUHqX+ppHgiOPwy7BGMg9d548OuD1kt8
::# WO6LB3y+QEsPJMJLtC8yYjpkXUD3WkXkBWFJfvKQPJJa2F2D4Wh/7MmTwC837t68d+sWgqBVwFlH
::# xDJQk9Gc/WGZ0b+Yvsn0LWe7Kz5ECsSeySNRZWBQlSBVKTCs9D0dHZZIS5bKLJG1ypl2uokcrBin
::# a/Y89C+HaObOoTW/aFQP0FpPop1grT4LnOZsy2K3aQGmx0wlkTt0GyrGSZFFLkCf6Rr+1jRzpiQo
::# B+k0J3No42LSirUARV5HnPJ6i3dILp6Y19MeQYJOz8oRWmrpti9aai5sGaeaQ9h2Q4Xcl7iyZdqz
::# 0d1FXClA5teW+Azx2TCqjoQLjRB27iSgBUyWz3c/SMztKe5cZJ/x+UL/oYAQsz7DNFGoGi9guXNO
::# rYMtrvYOqBg1r6eb++wmzcQcoKMrIR1WNYVqzan9r2T3eq5wmCvESp/CfDubaQFMBRwCGydrzY06
::# Apwxakfp9VzlMFeJNffJXBjnic/SxtuiOfMCy4f5pnnLdjlZ3zoB8Vm3Mptm/T1yOrHc2F71eq4h
::# mKAhIjE9j03WPsDTnNg1p1bcUMyTCUY3gU1matd6Db0tdCq4QxxzBlqy1G4vJI/tAMYC4ylsEJMA
::# s2iW0zgDNGuvH7RVDU4J7HepBZoKXgamk8/Jl6Tb/RW0lrXmwiy4BE44UDQrXHMZybVOBdp5KgCs
::# tVLl9ALLdcEwl1sYG3ifxHz4UJfwqjAz/m0urkdrabIFUuyYRCBV5pyEO8wHAnTWjBcsnbOPyzzk
::# ihNd6wwS54R5vOWeMiI6B0+SJDhLVhMiwBC5HoSrQQ/5nJgj1+2ZpD132EOggCJacl3UrMfp0xi5
::# CNcSNzf47RIM19HPPp4mWg5eHYgx2AaH/Td/iBYEs/v46Orqgqf0RInIITwhUKj7YkNDcD4EiDiZ
::# 4Lvo6hifeM49CN8NwMmB82373Cz2OHmjXnI2lZya8BMRq7FTuAZ1wPKV+dGKmqm15DErpp7cJWDD
::# db7jDgd3LKl9yeLsgq7sBbk+YgesjzVxMgH6WYUkkrMZlVHs7+iVn7QoA0OQ5bkL+XeIzP0A91N4
::# hYCMJj4ax7P2q3GAM3NLxnEORQK5Me3AdWhs9jJm6yhy9jsXX2TT4vlMzhAJq3aCMo7fQ0QSvIM7
::# EUhSiDgnGRCoRbWORuE0cOmClnwFUEsHCAC9ga13BgAAMQwAAFBLAwQUAAAAAABKPkddAAAAAAAA
::# AAAAAAAABQAgAHB1bGwvdXgLAAEEAAAAAAQAAAAAVVQNAAcse8Vq/9XFaix7xWpQSwMEFAAIAAgA
::# Sj5HXQAAAAAAAAAAAAAAAA0AIABwdWxsL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQNAAcse8Vq
::# Qs7Faix7xWptUj1v3DAM3Q+4/0Akyx0Qu+hHlnTrkLZLh6LdT7aoWI0sGiIVN/++pO6SukAnyxLf
::# 4+N77Lpuv8tuxjtYakr7nUceS1wkUr6Dq3uUcQKXPQTH0gUqqyseZEIYaymYBYbistaEQjNEYagL
::# S0E3wyHjExaYsTwg30DBwbEdqICPPCoPQ6LRJVipPB77q/2uMzX73fU1/HD8aMf7WFig1AynhyjA
::# 4qQydDycmqp2GZrIrlu0DE9wWKNMsE5OWn+eMCUQogSRwT25mNyQ8Ngb/acS88P/xqmLQsArBzS6
::# z1G+1KFh3vbwNTTMpXZyDJleB7dRFyqiJU6aShZaFPquAVWw6Uha6p+3fQ6ZtD1OMfvjDbB7BqYt
::# /P0Gfi5rr4Zyk5Ld/LXJolRDQugop+dTDz/zSPMcRdDDOLmsiYArCCFmBGc5qA36NbAn5MZaMFTG
::# jxBDuz//Wu/R6eGSHXoLfaWavL4AqeVrsUZ544PaSzmkOIrZHWKy9i+TwbdzTuJ4MgyjbJfk0uei
::# Wn348OKD+e7jk+2Xh8NAGlMzolG/GumpDdPW0GjPe9jD97/iGurNxdORahbeGn/7WhwzUG4sshIk
::# NY/vGkNdLEIPxUTC4UTJ933G9XRsRFaS6zzomBRA7+EcB5+XS59jMebOKIHr8AtHfTzM7jfc6gxL
::# qqZI12WT4z++qNaomS9mXxYV/QdQSwcIoQWwyQ0CAADZAwAAUEsDBBQAAAAAAEo+R10AAAAAAAAA
::# AAAAAAAFACAAcHVzaC91eAsAAQQAAAAABAAAAABVVA0AByx7xWr/1cVqLHvFalBLAwQUAAgACABK
::# PkddAAAAAAAAAAAAAAAADQAgAHB1c2gvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AByx7xWpC
::# zsVqLHvFanVQy07DMBC8V+o/jNpLK+FIPE6AOCJxQQjxAd0mm8Q0saNdpxV/zzq0pRw42LJ3dmZ2
::# 1jk3nwXq+R7DqO18VrGW4ofkY7jH4s1qSC2jHEU4JGyFQmmlCJ8U46BJmHqslC+/BkfxjQ/wNXqv
::# 6kOzLhbzmct289lyiQ/SXX4+e9EEGQM2jU/QRGlUON1usDr41OLQUuI9C7TlrjPp2MEraE++o23H
::# 6+xWtlzupkGPA2YdLrLBPxEm7LrAS51BYZCdYEqx73M0apkqxPoc6gpKX9AICpXJx8EUbk78k21L
::# xgwXnHOwvN3NA2I2O3jlvwjceNrY44/U08b0bwu8TtnrKCW73Hl2nGi2COFPLhNXWIUYXE2anHUf
::# SKq12fMQJU39LBLlcvi7Au+/sLCOXYINEAOj83atjqEyJ7uZhxUaXhv5G1BLBwiIhveNQQEAADgC
::# AABQSwMEFAAAAAAASj5HXQAAAAAAAAAAAAAAABMAIABzcGVja2l0LWF1dG9ub21vdXMvdXgLAAEE
::# AAAAAAQAAAAAVVQNAAcse8Vq/9XFaix7xWpQSwMEFAAIAAgASj5HXQAAAAAAAAAAAAAAABsAIABz
::# cGVja2l0LWF1dG9ub21vdXMvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AByx7xWpCzsVqLHvF
::# aoVZW08bSRZ+j5T/0Jq87CI5VvamFW/ZJJqJMtJkc9E+RNHagU5iJVzWl8zsm7sbjG8EQmIgQMLd
::# NvZgQyCE2GD/ly1Xd/tp/sKec6qq3QZGeTF2X6rO5Tvf+U4RCAQuXxoNj+iDWmxcH3oRiQfCifjY
::# 6NjIWCJ2+dKwHhuKRsbjkbHRQY1ZRWadMPMIP408S+bdqQpv5ZwPSTuTY8lpZpTt/JSz1WDGAjNW
::# 4Scz4GK1c9p23sH398yEx8zvI/EfEk+0+7CfdicS15hRo82vjgwHx1+GR/FvPBx7EYMvcLPKW2+Z
::# McGShr1S6Zyu2OlZZpSYYTIzz4w9ejXy9L/BoZfhKP7FJcT7uLLzbpVeyDEzA0vw2qq7Ocmspr21
::# 4pZP4Auv5TuNlLPRcCtgawuXNuc6jUZ3HnY9hhXcgwovzDBzQj1TIfdK0vmlCTCxm/zETIPWx9V4
::# K//bSZpWgyjUnRX4rDJrnlm7zLKYWWdGgaxf5WuHfDb920kGH8Dny7iOUeRr+/xN1guZF2u0fz2P
::# sfaiTwZIv8R1YbCxzIwleyUJxgi/IHbM2ITFRaowpvhztdP60F07QQNMU6YqaV6+FEBoXL50pZeo
::# 6x4ytFu/6EMJhIX2Bz8I/ohvnMnvoPY8Hh+PDQaDzyLx54knV4fGRuTXIOYuAKCjja5oP73So68i
::# +s/48yJ41SHCbtHoNI94bclp7UCQJXAggv9LzbnltPOuCVcljMRVZraZ+RWiztMpt7QJtxW6xH0R
::# O/giMEFXKIsyBxITsHc3+a5zvIuhlPioylhbTQUODDpC/jhp7y10k0vuJ8hrSeIDcmltYPVYgEXz
::# 0SNVclH9P4lIVH/8GBFr7zfAO2YVCC0IUYlh+GkeS/yAOcYHeJisa/HUNE/vUI0tgJniFp9M4wPJ
::# vMLGSp9bEE9zzplYB1d4ft5DGoae11vu/jqEmx9DAVSvMWMLVrp/99YN+AWOonlYAkVRVliT27ti
::# BQiuPb/nFme0sahmL2zw3UW3feqWF9Gg9JY9D8/VtdAZx0Pgd5nPAk4XsRSEFYAHYQg+7MUF75x9
::# PXj/zu0ff4R84jro8ZkQDmrCJkEe5yyjSPjDCUXAjNQgbhXoYz0+uc2zkOEqxiJw+ybkRuKPWW8Q
::# Y1YTYUvLBsUesLrixLzHWXz6AEz0xTygue0vsKegAwpR9JkWGNW+u6LZO6uuddppFuzS4uB3RHex
::# IBkwEJS7U/yYKeBSlwAzSsICypuJ4HYON/r2BJC6U4fXoJyQ1MyMiofhbk3ZhT1xG2GQfO9uruAa
::# M7OK3Ytd49jOfsSL+6bANlHeW4wiFtwWs1aZdcDMPYprW5SMKpM8b09CJSO1QVCQiVr0WUFrncxX
::# ghiUe174DUtA4bmNKtFAzd3ZpxZQJzKegceYsaMgas65pSI6aeR8RJfimWk0X+5fQ2Ymxu4jGQAp
::# QY5vzdOLAtKZvnipBoAR8+Oqr4QAvHefh2O6dl001v6ulIfMAIrsGUsSMlho5kTyift8YATnxEo3
::# BjXVvaB5lAiUDfJQtJ/k2a3/cfHWXhO1mp3jaeAEPgmeVlQnSsuAEOeA7xcVnK9eJd6AkjzCMudk
::# lxIBQaVgDAzI9nwBeYpgGhMDA1Ry165qAwOyqcMlLXRVdfi4PgK+xPVYEFrISHh0OBaUt1TtQw67
::# aynYQ5UlUJwUADI5/ozZ703EEPUGZlWYtcCsNJ9qUI3XtNC/frp358G9W7f+fff6gx9w/apTavJc
::# QRRAp7ndfT/tJz9KwJ/QfOlsL5oZ7PHf9Ea+prxxiwcOGAeFvDxvL5bwO5TbIWw+AVbinhTb0PXY
::# i4cxPfrPhB7Dlozv1pHDzBkRWHTbW8F4R8iugjKAfs+L2/z0LcmgjMABkkZtiSe3sJDA+DSGE9mK
::# qkXF1ajdIFsjQ2HcMsbMJrWlL8wqYdVDB2xud46pok43+MkMLrL4mhoBhgoyrWka0B5BgKcmee2r
::# FtTs1+uyixmrniHedWc25bzbh6B2TguIsokK9TihNXOEVbFoMUfxWRAU0l/hoHLSWGxEB1Q+FSQP
::# bO5L1O9qMgt8+aOzi8Hi+QZPbxPhTGOW4X0jRXrNS/qfMelYZ99MsVQmoT5h23tjRB8Zi4KWhZDG
::# I3FSWF5fMz8Rs6fdnUKntY5QaCTJdUSjXNfZzZzH/OVLf0H7iAK+aaDSRj4L1aXzKz+4eTPIrBS1
::# vjTwOfYC2edyXi/zHvCEGCavPQlKic9WpS4S3BUS3Y0+ld8izbxRRCWUPbInc4jb9iK10iV7+RBK
::# +mLuvZAxffIPCeMoDepH0lxA893xGwsKGRppd36j0zaJNos8vcBn6ny2iGvkp6hdQQfKMjPbU+P+
::# XguR+r348K19u7Agn+7Fao7AXbWXj6mBSbHlXxpcefQo/EwfjQfienhEyEctFB8eDjxLRIZ1SSJG
::# d22x18T47ETPNaoPb09IJVBBFcUDcXh3CbWO+3kPZydUtkU5NfnEn9CUdmafjPRqAiUVb33ljYKQ
::# pP7AWgYlg3SstaIELXHb2WRCLW9NdZffYH8SjpsTyoYqyaSe+yHh/dDYsB4IR4eeR+L6UDwE5CEu
::# RXWcLPQoXXmSiLwcDujR6FgUbsTGXr4SNyA4bjnpVj6qp7GeEAufcXozywShYzL/QCQJfFP9DLpP
::# G8UF+JFfpea9pAjU074l+7CpGK5ITDKh8kL+0XhRdd43oNAEs7nlXRhrxPuosKwd0lbz+MWqgApD
::# 7MHg+eaUz8L0ZziHe12r7MkmGHi6U2lBcggC00SLvbtlEMF7Tn2CL38CEvbP1V6X9k825xsCTJew
::# AnrYNzNVYeVu/tPZujzT8cXGGLnF1zhXYCWmu1PTqAwh4xuWU8g7X5ZkefbxuDdHGXlnxXAK20pt
::# gGyqDwyIKRFrlVw9K/vUVD8woFzOkkgRXVA8Le/VvR6qOlr9dwyBIdFUTURyAdVFCpxSNkrHwSM5
::# XjjAAptZGOLtt6glpCibqXeTKXEFXn46Fh3StfFE7Dn2ChidNcCsHtcCgefh6HAIJz6JBwClwTPZ
::# 7vstTM3+tr17SPwBvQ7SlwY0UywBbZP79koG+zVWfopZa0hbp/vd1bYIpGcOSGHAkzgK4ZO/dudz
::# IO0c4lFp0d17wduxWEKXstIEfgE71mWJgB1iBayhE2QYFCG4mp0tOOU2Wb9OLNAU5dUFgLbXe7b6
::# ncNBQKlXnp6yl9tgxzl5GvSuJMaHob0pvUqgrzrAw7sbkFB1QnFGAQKk0HUz9/NY9EU8qutygPGd
::# YklE4rgDxYLsqAYapKWKOFfpNcCeuFA9ou8ozSsxWSz9gqUuhqq+Eyqj3t2EhO7hOZKCpyyxbx42
::# YQhbOUgKnyqCosLXPK3maRuooN7pkk8T0t5KK1aBXGiOJWUkNby3CYTMO4vwN1O/aWf6hqwJRT1Q
::# LDk7b5DGwcXBf2B+25oElukh09xgJqiIosRbj2sxJd21tJjcsjTZ5s/UITQqxUFVd+cTSmE/+lVW
::# aQkiEiJJ6TcUKgzmsJCzuuwst1Rjz5LXOz3uNeeApZn5VjCEPHoQ/GSU3fUPTsUQuypIgQsyiPgC
::# hLoDdkFXAdAid8l8S3t7vbwsw425rgrJItYFjnaOlnxPUm4gE/iTMgG4pzbdac4TleP4BiQk3PPL
::# BVinN9nB8O7LpRDxBA9/Jyj5jzXVAUJ/V/C/AOUs0oZntAvb9sqv0I1luamxsqZONatCRUr4guIQ
::# crL/+BRXhKF+Z1/2VllHddWk/XwMs6c4AFAHPGi4OMxIozLyBqBzB9UkbPAMiCZA/9GsPIyiZi6n
::# DtWWFFJreLJQLIGlcnIXx1jfGFww21mq2AOfeKj1C4YMDSciwnJUUukUm+IyPhwEL2SOPpRRRYtZ
::# jCaLnma1mj0FqWDkfJ61P65cvvRXsGIrAwqPxPg6xbTqd50aWywejidiQOD4Yzjy9Ck0ObwWgqEO
::# pM0EOfS3qx5F1Gi1HXXysKHA7NFxxecP2HVCh1RS4khYAQK/T0AjjYYjL2Pq0K/XckS/CYpug90f
::# IKgmaxJkPSp3ausQl57WRhRpt2+qCbgu4KqFCF2PHj68ffPv9rrxGNoTTFZHu8R1Pu1LE/5XLBtV
::# CPhvB5JsSH/9/yIgsUys4okdpbbqPb6jAwNPcwQ9rREE2AOfSrqX7Of1nPo52oTt/g9QSwcIxAK/
::# 5TcMAAA7GgAAUEsDBBQAAAAAAEo+R10AAAAAAAAAAAAAAAAQACAAc3BlY2tpdC1yZXF1aXJlL3V4
::# CwABBAAAAAAEAAAAAFVUDQAHLHvFav/VxWose8VqUEsDBBQACAAIAEo+R10AAAAAAAAAAAAAAAAY
::# ACAAc3BlY2tpdC1yZXF1aXJlL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQNAAcse8VqQs7Faix7
::# xWqNVktTGzkQvlPFf5gKl8VVZir7uHDbWrKbVA5JkVTtcXHMJLiIDTszJLs3a4aHsQ0GEtsQ2JiH
::# AWNiEwJFvBjwf1lZmuGUv5CWNBo/SNVysSWN1Oru7+tPHQwGe3tioag2qBiTWng8YgZ17c+piK71
::# 9oxqRliPTJqRidig8lvEvD/1THkCm5SHEVP5bsw0J41BVX0RMcemng2EJ6LeUGWGgmCpX8HWSvOy
::# gdEORnvuHmrWz0j1nXN1gK3pZj1L91eblxs0sfTlIiGmTiUHG7BdF1O6XhMb/BW3VHFLCTBLlg6x
::# Ff9yMQ9jmvvo7mW8negKowJGRzS/TSqr4hRGNbdx6ZZgkMdxxPwbiI6qky9DMfZvhoxxAwb87L7z
::# tiBupOunYBmjNWylcNzq8D+OxBTMkuSmSorzsBtWnw4NkfkFmgE/qmIHzZ46S7PwSbpSpauLNDdH
::# 0jlYlOmEZeZV5PnfavhlSGf/zDvhGraz2K5g+4JUC+5WGqM0PbawhbAF0aeZd6iE0QJGh5Bs520J
::# nO3tCTJge3v6lGEBZ1SLmYYPH/vUheig8v+Icot9yqNXmv4qor3+hhUFIsF2Gdv/YKuG7QSMyewM
::# tmexfYLtPLY/QBxsHVy2/sXWEd+cZyseV6b95EqurPgkkJDkgU+KB6Py3+yK4kHJxxJOxj5STXNS
::# ZDFaFzB2kiUlaCLZkWJHEkWaqwimkKMr93hLefL43i/MmrN9zujJr+eb55md3YrPES8/9Jjvk7AN
::# Ku2XKhO60n4rOxNUsL3HEmOdMZhndklyHahIFk7AlLA+yL0IPhhqERgOLbMkxpHPehxPC6uquALH
::# F2h6zimCEeCNxeiCPspofaeDitv4jNEs2TwlSwm/ePy4aXHDOd2WfozoL5RgTLkDcR4UXPtSEHvw
::# DgfEULmbAdXzcQQIUWrW6oAotioc+yP+Ow/xNWtxd+4UsuqWFzrcER/A57tAA4zKkOkup93iHM1+
::# lPvYBhJfc3c2QEpknhjDGtgqchYeelKRWeLJYAheoxpNvmeLXjXduN2Z3sJoWSStkzcdqWOO0TUL
::# 8tbBF1RVXk/o46auaepzLWRO6RoglsP2Aa8FxBLQRh/wfGRAioAQXkN9FjLG1PAYCHNwUte4MhsR
::# UzMGjDGW2SO6EQfHfKAgJIzOGBUsxAL2GellnZWbR0q4zruMF42nOn4xtSoJ7AgjfcrdfsU7I0jb
::# 8tfUonAKHFNBNaKh2Kihep8EB6wVtwxxNlhtl1ZdcA1k4kb93yXr76XGtWX4W9dwRZJTeQfTPtCP
::# Nm1g6OZ36cYHt/yeFVQh1YF0O6gCwS6nyNw5L8WqMvL7o+GHT4fv3fvj8c9P77PkHzr7dZLKCjI1
::# 67vXa0DiqgcpBMyimJUXtRW8uMg9+EQu32Crzq6zPmN7n7ECsoIaLZVjSpgCH2B8vQkSWv912MmW
::# SeYzozw6gO3X8R1YYbGfVWgadeQNHiOVKS+EZCegABnPPRlI+aXuq23r5UwskWSBFM7peQ6iZJIy
::# V2aBSlNghDRmrjcToC6QVGGQ5kss2auL3dIyImSB/0qg2iMMBMh0mcwkyPleIABFGwg4yTM6k4IJ
::# iHFjBqN3kjKyTKYmRwH1IOdAJDaq/SXKwXtApIxZFllKgzK1F0Kf8n2/5PotOOzt9HTskFy9aUHq
::# npRJNiNqkBT3f8KoCFtochkjSAyiiyWyWwJCO5W3bcLTlhjvGzpqsRWahm/TosaegjWLZBbo6mbX
::# c9On/NDPa/YWAXnv5M1oWqeiWnRChzZkImaYEXOKdX8SNpKxnJl9ARu2PomX3D3INq+2WIjncU6g
::# NRkfrx3ASz7OqqJrhhbSw2NiBiCGgtGJUe2lmIO4hccNM6SbYg4umHooDDIoxNvrzLqj/7FfCNUt
::# wpetwc34b1crfgWwh4ULhaQo70fblKXVhLB+CD4AjranLNwEudwmFxnIzoMh9YnJMs6k2driD9ah
::# eNlF2GTxhFQT3T2Gr0xk85gsJ0XwIkNqW5tUkOQCyDwcYNTpHW8i4B5uqIOidKPs7u/wHoS1raz/
::# gbYV+s9qqktDOvoXSXpy1eqU6Ad4S2vX8U/QtnPrXwFQSwcICssQGyEGAAB6DAAAUEsDBBQAAAAA
::# AEo+R10AAAAAAAAAAAAAAAAPACAAc3BlY2tpdC11cGRhdGUvdXgLAAEEAAAAAAQAAAAAVVQNAAcs
::# e8Vq/9XFaix7xWpQSwMEFAAIAAgASj5HXQAAAAAAAAAAAAAAABcAIABzcGVja2l0LXVwZGF0ZS9T
::# S0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUDQAHLHvFakLOxWose8VqhVZdTxtHFH1H4j+MwkuhWTb9
::# VMtbFFAatVWrRigPSSQbewlubGzZJihvnl3irD+oKUkwJCbBiA/HxCZOCE0Cxv+lw+zaT/kLvXd2
::# vV6vW1UCaz2+c+eec8+5s5IkDQ/N+yPKBEnElMDdUFJaiAX9SWV4KKgkAvFQLBmKzk+Qq6HkDwsz
::# 5DrEkB9DSfLZXDIZS0zI8p1Qcm5hZjwQjdiPMuaRINEoYbTOtA2mnTL1A9NWxMN7pu0z7a3x7MhY
::# e83UJaal4SvTikx7hQGaLmO0esi0qljV+UreKL1g6mq7nGc0zSg8U0htZHKdrTRLqd2icM1Km6Ln
::# 77PGOypyVO0CaAUC+F91rqc79KX5uAJhSSUSCwPahAwAIv75YEK2QCcwtrDG1Gz77JTRFsQyrSYy
::# HTDtoENzkODTqW4Ud43Sq3b1Oc+vMe2EafD5UgCinc3nxqPl82YJ1q//OnVFujk9fW3yO6NMb386
::# zUB+87hm5AFJnrcetPfgoSpqXGb04LzZwgLpBlNzgHB4SMI+DQ+N9DowbbdpeMjTmwny/70RuUbI
::# L/eU+L2QstjLwh+84qcF0o3DFiKhbh7VVaO4zWvrYmVTdFTHZ1onvnHcGJq9L/tg5wEvLBvrW4wW
::# gT17D61b1AGHotsHXg6R53/jMEWRQ3Jtkje3oUJkUF09b20KBosoCnoGf7YAesQJnDei8buz4eii
::# 9XWEfDFKzMKZmT02slmjUMZliXjw8PQDhNRj4j+UDGWYmQ+8/tQ6FPCcn+UmiC9+h0jz5MK9S7du
::# jeP/zUvS97c/v+DDykVHe6nNxw1jcxcVd3jWbpQhI9eLRn7Dk7FH7kX4Egj7F4KKS7eWfcfHxiNB
::# 5xAL7pejpOuHvtLN7Y/t6rKF3mp/H2KjlBIebTH1teyRgLXVKfCGMmPslMyjbdEF6MWhte38faq9
::# t9+DbLWnCxMjUE6Nj+joFG2/fMObj5x14gPVkkA4Oq+gnPbBj/ys6OntCPlqlFiutn634Nh4RarO
::# 2iMSDM3OQo6cMxr+Tq+6DW0HAPPeQyTCdzJQt9ObzsNlU/3gJmBieIgQifh608Q3sOL0qfuTPWdk
::# 6JU+40/MybHoohJPzCnhMPBlB0WUSDR+H/dIpN1q8uyWzDPZzsYO054wFarZQSOpKkwQRp9aah4g
::# 6GuYxH2zC4dfH02gPIER0LkjXRZ20TE2Bqd1tnQx3XvBXD82j5aQwfSydcTYmE0MbqcwgPccp9vr
::# LqfbNoepuEeN2jaQ4rkG4FqAuOciGqbnAQnMgeCjC0k5sRhKBubkQFwBpuGwvFHPMTUj5umSw6U9
::# PuD3Q+LzzGPBr2dCWZqCbIyqAJ5vHfEVHYWdouaLGmQ2V9JgXLyXKuud/JsB2r9B2mFKAUW7TCuL
::# wnXLAN2B0+fGdrkCmdAPrhnmmP/KT5enJ6fQ2xddk+C3qcuTP0+5He94rLFr1I4GywcV4SneYr8d
::# JWDgdgXuugrfavA/s12BnODV1N8K1EvuCbYLwJ80GS14xoFPkkDHMSxVkn5PROd9xKxleiXCcBSO
::# bucaIAa8Y+o55F5dMor7/04LAsF+gofdh/VZ1MQy3wmRVKFNvNnovGiZh0v82Ru8gUpV8DBvlZzX
::# AOR6/Q9Ih0IXoL0Xx9UFfzwY94fCiW7LeooF/Ia+InP9ofGshczC64la6KoOrpA9AeMYPs16GdTS
::# w9/VonWXwV7Lv4O6xInUfU1wwXVsaxM48A4FKR2vATizddKuvBX35B4OQTUz4Ot/AFBLBwjkYBbK
::# KQUAAAkKAABQSwECFAMUAAAAAABKPkddAAAAAAAAAAAAAAAABwAYAAAAAAAAAAAA/0EAAAAAY29t
::# bWl0L3V4CwABBAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQACAAIAEo+R13bz9o/GAIAAJ4DAAAP
::# ABgAAAAAAAAAAAC2gUUAAABjb21taXQvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVAUAASx7xWpQ
::# SwECFAMUAAAAAABKPkddAAAAAAAAAAAAAAAABwAYAAAAAAAAAAAA/0G6AgAAY29tcHVzL3V4CwAB
::# BAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQACAAIAEo+R12ftmEBPwIAANsDAAAPABgAAAAAAAAA
::# AAC2gf8CAABjb21wdXMvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVAUAASx7xWpQSwECFAMUAAAA
::# AABKPkddAAAAAAAAAAAAAAAACAAYAAAAAAAAAAAA/0GbBQAAZmVhdHVyZS91eAsAAQQAAAAABAAA
::# AABVVAUAASx7xWpQSwECFAMUAAgACABKPkddw/QXUswGAABgDAAAEAAYAAAAAAAAAAAAtoHhBQAA
::# ZmVhdHVyZS9TS0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQAAAAAAEo+R10A
::# AAAAAAAAAAAAAAAIABgAAAAAAAAAAAD/QQsNAABoYW5kb2ZmL3V4CwABBAAAAAAEAAAAAFVUBQAB
::# LHvFalBLAQIUAxQACAAIAEo+R11ttQoRNgUAADIJAAAQABgAAAAAAAAAAAC2gVENAABoYW5kb2Zm
::# L1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQFAAEse8VqUEsBAhQDFAAAAAAASj5HXQAAAAAAAAAA
::# AAAAAA8AGAAAAAAAAAAAAP9B5RIAAGhhbmRvZmYtc29ubmV0L3V4CwABBAAAAAAEAAAAAFVUBQAB
::# LHvFalBLAQIUAxQACAAIAEo+R11qV2qqZwEAAKMCAAAZABgAAAAAAAAAAAD/gTITAABoYW5kb2Zm
::# LXNvbm5ldC9sYXVuY2guY21kdXgLAAEEAAAAAAQAAAAAVVQFAAEse8VqUEsBAhQDFAAIAAgASj5H
::# XRtc5FJhBwAA5Q0AABcAGAAAAAAAAAAAALaBABUAAGhhbmRvZmYtc29ubmV0L1NLSUxMLm1kdXgL
::# AAEEAAAAAAQAAAAAVVQFAAEse8VqUEsBAhQDFAAAAAAASj5HXQAAAAAAAAAAAAAAAAwAGAAAAAAA
::# AAAAAP9BxhwAAGktaGF2ZS1hZGhkL3V4CwABBAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQAAAAA
::# AEo+R10AAAAAAAAAAAAAAAATABgAAAAAAAAAAAD/QRAdAABpLWhhdmUtYWRoZC9hZ2VudHMvdXgL
::# AAEEAAAAAAQAAAAAVVQFAAEse8VqUEsBAhQDFAAIAAgASj5HXYhLbrSBAgAAQgQAABMAGAAAAAAA
::# AAAAALaBYR0AAGktaGF2ZS1hZGhkL0xJQ0VOU0V1eAsAAQQAAAAABAAAAABVVAUAASx7xWpQSwEC
::# FAMUAAgACABKPkddKls4JWANAAC1HAAAFAAYAAAAAAAAAAAAtoFDIAAAaS1oYXZlLWFkaGQvU0tJ
::# TEwubWR1eAsAAQQAAAAABAAAAABVVAUAASx7xWpQSwECFAMUAAgACABKPkddt3S3jNYAAABKAQAA
::# FwAYAAAAAAAAAAAAtoEFLgAAaS1oYXZlLWFkaGQvVVBTVFJFQU0ubWR1eAsAAQQAAAAABAAAAABV
::# VAUAASx7xWpQSwECFAMUAAgACABKPkddO5WuK5UEAACFCAAAHgAYAAAAAAAAAAAAtoFALwAAaS1o
::# YXZlLWFkaGQvYWdlbnRzL2dlbWluaS50b21sdXgLAAEEAAAAAAQAAAAAVVQFAAEse8VqUEsBAhQD
::# FAAIAAgASj5HXRXSQmOvAAAA9QAAAB4AGAAAAAAAAAAAALaBQTQAAGktaGF2ZS1hZGhkL2FnZW50
::# cy9vcGVuYWkueWFtbHV4CwABBAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQAAAAAAEo+R10AAAAA
::# AAAAAAAAAAAKABgAAAAAAAAAAAD/QVw1AABvdmVybmlnaHQvdXgLAAEEAAAAAAQAAAAAVVQFAAEs
::# e8VqUEsBAhQDFAAIAAgASj5HXRrCdc0GCQAA+xAAABIAGAAAAAAAAAAAALaBpDUAAG92ZXJuaWdo
::# dC9TS0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQAAAAAAEo+R10AAAAAAAAA
::# AAAAAAAPABgAAAAAAAAAAAD/QQo/AABvdmVybmlnaHQtZ29hbC91eAsAAQQAAAAABAAAAABVVAUA
::# ASx7xWpQSwECFAMUAAgACABKPkdd9Q7sDSQIAAAPEAAAFwAYAAAAAAAAAAAAtoFXPwAAb3Zlcm5p
::# Z2h0LWdvYWwvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVAUAASx7xWpQSwECFAMUAAAAAABKPkdd
::# AAAAAAAAAAAAAAAABwAYAAAAAAAAAAAA/0HgRwAAcGlja3VwL3V4CwABBAAAAAAEAAAAAFVUBQAB
::# LHvFalBLAQIUAxQACAAIAEo+R122DeSJAgYAALoKAAAPABgAAAAAAAAAAAC2gSVIAABwaWNrdXAv
::# U0tJTEwubWR1eAsAAQQAAAAABAAAAABVVAUAASx7xWpQSwECFAMUAAAAAABKPkddAAAAAAAAAAAA
::# AAAACwAYAAAAAAAAAAAA/0GETgAAcHJpb3JpdGllcy91eAsAAQQAAAAABAAAAABVVAUAASx7xWpQ
::# SwECFAMUAAgACABKPkddAL2BrXcGAAAxDAAAEwAYAAAAAAAAAAAAtoHNTgAAcHJpb3JpdGllcy9T
::# S0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQAAAAAAEo+R10AAAAAAAAAAAAA
::# AAAFABgAAAAAAAAAAAD/QaVVAABwdWxsL3V4CwABBAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQA
::# CAAIAEo+R12hBbDJDQIAANkDAAANABgAAAAAAAAAAAC2gehVAABwdWxsL1NLSUxMLm1kdXgLAAEE
::# AAAAAAQAAAAAVVQFAAEse8VqUEsBAhQDFAAAAAAASj5HXQAAAAAAAAAAAAAAAAUAGAAAAAAAAAAA
::# AP9BUFgAAHB1c2gvdXgLAAEEAAAAAAQAAAAAVVQFAAEse8VqUEsBAhQDFAAIAAgASj5HXYiG941B
::# AQAAOAIAAA0AGAAAAAAAAAAAALaBk1gAAHB1c2gvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVAUA
::# ASx7xWpQSwECFAMUAAAAAABKPkddAAAAAAAAAAAAAAAAEwAYAAAAAAAAAAAA/0EvWgAAc3BlY2tp
::# dC1hdXRvbm9tb3VzL3V4CwABBAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQACAAIAEo+R13EAr/l
::# NwwAADsaAAAbABgAAAAAAAAAAAC2gYBaAABzcGVja2l0LWF1dG9ub21vdXMvU0tJTEwubWR1eAsA
::# AQQAAAAABAAAAABVVAUAASx7xWpQSwECFAMUAAAAAABKPkddAAAAAAAAAAAAAAAAEAAYAAAAAAAA
::# AAAA/0EgZwAAc3BlY2tpdC1yZXF1aXJlL3V4CwABBAAAAAAEAAAAAFVUBQABLHvFalBLAQIUAxQA
::# CAAIAEo+R10KyxAbIQYAAHoMAAAYABgAAAAAAAAAAAC2gW5nAABzcGVja2l0LXJlcXVpcmUvU0tJ
::# TEwubWR1eAsAAQQAAAAABAAAAABVVAUAASx7xWpQSwECFAMUAAAAAABKPkddAAAAAAAAAAAAAAAA
::# DwAYAAAAAAAAAAAA/0H1bQAAc3BlY2tpdC11cGRhdGUvdXgLAAEEAAAAAAQAAAAAVVQFAAEse8Vq
::# UEsBAhQDFAAIAAgASj5HXeRgFsopBQAACQoAABcAGAAAAAAAAAAAALaBQm4AAHNwZWNraXQtdXBk
::# YXRlL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQFAAEse8VqUEsFBgAAAAAkACQAIgwAANBzAAAA
::# AA==
rem ---- qwen-settings.js as base64: lines starting with "::~ " ----
::~ Ly8gTWVyZ2VzIHRoZSBTdHJhdGEgc2V0dGluZ3MgaW50byB+Ly5xd2VuL3NldHRpbmdzLmpzb24g
::~ KGV4aXN0aW5nIGtleXMgYXJlIGtlcHQpLg0KLy8gR29hbDogUXdlbiBDb2RlIGtlZXBzIHdvcmtp
::~ bmcgZm9yZXZlciAtIG9sZCBjb250ZXh0IGlzIHN1bW1hcml6ZWQgKGF1dG8tY29tcGFjdGlvbikg
::~ aW5zdGVhZCBvZiBzdG9wcGluZy4NCi8vIFRoZSBpbnN0YWxsZXIgZW1iZWRzIHRoaXMgZmlsZSBh
::~ bmQgcnVucyBpdDsgcnVuICJub2RlIGJ1aWxkLWluc3RhbGxlci5qcyIgYWZ0ZXIgY2hhbmdpbmcg
::~ aXQuDQpjb25zdCBmcyA9IHJlcXVpcmUoJ2ZzJyk7DQpjb25zdCBvcyA9IHJlcXVpcmUoJ29zJyk7
::~ DQpjb25zdCBwYXRoID0gcmVxdWlyZSgncGF0aCcpOw0KDQpjb25zdCBNT0RFTF9JRCA9ICdzdHJh
::~ dGEnOyAvLyBzdHJhdGEtcXdlbi5iYXQgc2V0cyBPUEVOQUlfTU9ERUw9c3RyYXRhOyB0aGUgc2Vy
::~ dmVyIGFjY2VwdHMgYW55IG1vZGVsIG5hbWUNCmNvbnN0IGZpbGUgPSBwYXRoLmpvaW4ob3MuaG9t
::~ ZWRpcigpLCAnLnF3ZW4nLCAnc2V0dGluZ3MuanNvbicpOw0KDQpsZXQgcyA9IHt9Ow0KaWYgKGZz
::~ LmV4aXN0c1N5bmMoZmlsZSkpIHsNCiAgdHJ5IHsNCiAgICBzID0gSlNPTi5wYXJzZShmcy5yZWFk
::~ RmlsZVN5bmMoZmlsZSwgJ3V0ZjgnKS5yZXBsYWNlKC9e77u/LywgJycpKTsNCiAgfSBjYXRjaCAo
::~ ZSkgew0KICAgIGZzLmNvcHlGaWxlU3luYyhmaWxlLCBmaWxlICsgJy5iYWsnKTsNCiAgICBjb25z
::~ b2xlLmxvZygnc2V0dGluZ3MuanNvbiB3YXMgbm90IHZhbGlkIEpTT047IGtlcHQgYSBjb3B5IGFz
::~ IHNldHRpbmdzLmpzb24uYmFrJyk7DQogIH0NCn0NCg0KY29uc3Qgb2JqID0gKG8sIGspID0+IChv
::~ W2tdICYmIHR5cGVvZiBvW2tdID09PSAnb2JqZWN0JyAmJiAhQXJyYXkuaXNBcnJheShvW2tdKSA/
::~ IG9ba10gOiAob1trXSA9IHt9KSk7DQoNCi8vIG5ldmVyIHN0b3Agb24gdHVybiAvIHRva2VuIGxp
::~ bWl0cw0KY29uc3QgbW9kZWwgPSBvYmoocywgJ21vZGVsJyk7DQptb2RlbC5tYXhTZXNzaW9uVHVy
::~ bnMgPSAtMTsNCm1vZGVsLnNlc3Npb25Ub2tlbkxpbWl0ID0gLTE7DQoNCi8vIHN1bW1hcml6ZSBv
::~ bGQgY29udGV4dCBlYXJsaWVyIHRoYW4gdGhlIGRlZmF1bHQgODUlLCBzbyB0aGUgMTMxMDcyLXRv
::~ a2VuIHdpbmRvdyBpcyBuZXZlciBoaXQNCm9iaihzLCAnY29udGV4dCcpLmF1dG9Db21wYWN0VGhy
::~ ZXNob2xkID0gMC43Ow0KDQovLyB0ZWxsIFF3ZW4gQ29kZSB0aGUgcmVhbCB3aW5kb3cgb2YgdGhl
::~ IFN0cmF0YSBtb2RlbCAoMTMxMDcyIHRva2VucywgYSBsaXR0bGUgbGVzcyBmb3Igc2FmZXR5KQ0K
::~ Y29uc3Qgb3BlbmFpID0gKG9iaihzLCAnbW9kZWxQcm92aWRlcnMnKS5vcGVuYWkgPSBBcnJheS5p
::~ c0FycmF5KG9iaihzLCAnbW9kZWxQcm92aWRlcnMnKS5vcGVuYWkpID8gcy5tb2RlbFByb3ZpZGVy
::~ cy5vcGVuYWkgOiBbXSk7DQpjb25zdCBlbnRyeSA9IHsNCiAgaWQ6IE1PREVMX0lELA0KICBuYW1l
::~ OiAnU3RyYXRhIChsb2NhbCknLA0KICBlbnZLZXk6ICdPUEVOQUlfQVBJX0tFWScsDQogIGJhc2VV
::~ cmw6ICdodHRwOi8vMTI3LjAuMC4xOjgwODAvdjEnLA0KICBnZW5lcmF0aW9uQ29uZmlnOiB7DQog
::~ ICAgdGltZW91dDogOTAwMDAwLA0KICAgIHN0cmVhbUlkbGVUaW1lb3V0TXM6IDkwMDAwMCwNCiAg
::~ ICBtYXhSZXRyaWVzOiAyLA0KICAgIGNvbnRleHRXaW5kb3dTaXplOiAxMjAwMDAsDQogICAgc2Ft
::~ cGxpbmdQYXJhbXM6IHsgbWF4X3Rva2VuczogODE5MiB9LA0KICB9LA0KfTsNCmNvbnN0IGkgPSBv
::~ cGVuYWkuZmluZEluZGV4KG0gPT4gbSAmJiBtLmlkID09PSBNT0RFTF9JRCk7DQppZiAoaSA+PSAw
::~ KSBvcGVuYWlbaV0gPSBlbnRyeTsgZWxzZSBvcGVuYWkucHVzaChlbnRyeSk7DQoNCmZzLm1rZGly
::~ U3luYyhwYXRoLmRpcm5hbWUoZmlsZSksIHsgcmVjdXJzaXZlOiB0cnVlIH0pOw0KZnMud3JpdGVG
::~ aWxlU3luYyhmaWxlLCBKU09OLnN0cmluZ2lmeShzLCBudWxsLCAyKSArICdcbicpOw0KY29uc29s
::~ ZS5sb2coJ3dyb3RlICcgKyBmaWxlKTsNCg==
