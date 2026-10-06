@echo off
rem One-click installer: Strata (Qwen3.8-Flash-Next IQ2_XS) + Qwen Code.
rem Safe to run again: finished steps are skipped and the model download resumes.
rem Context is 131072 tokens (docs: measured on a 12 GB RTX 5070). Needs about 80 GB free on C: and a few hours for the ~70 GB download.
setlocal
title Install Strata + Qwen Code
set "STRATA_DIR=C:\Strata"
set "MODEL=IQ2_XS"
set "CFG=%STRATA_DIR%\strata-iq2_xs.json"

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

echo [3/7] Setting up Strata with %MODEL% (the model download is about 70 GB) ...
if exist "%STRATA_DIR%\run-iq2_xs.bat" (
  echo Already set up.
) else (
  call "%STRATA_DIR%\START-HERE.bat" --yes --family qwen --model %MODEL% --context 131072 --no-start || goto fail
)
if not exist "%STRATA_DIR%\run-iq2_xs.bat" goto fail

echo [4/7] Allowing long replies in the 32K context (fit_max_tokens) ...
findstr /c:"fit_max_tokens" "%CFG%" >nul 2>nul
if errorlevel 1 powershell -NoProfile -Command "(Get-Content -Raw '%CFG%') -replace '\"port\": 8080,', ('\"port\": 8080,' + [Environment]::NewLine + ' \"fit_max_tokens\": true,') | Set-Content -NoNewline '%CFG%'"

echo [5/7] Installing Qwen Code ...
where qwen >nul 2>nul
if errorlevel 1 (
  call npm install -g @qwen-code/qwen-code || goto fail
) else (
  echo Already installed.
)

echo [6/7] Creating strata-qwen.bat next to this file ...
powershell -NoProfile -Command "$o = Get-Content '%~f0' | Where-Object { $_ -like '::| *' } | ForEach-Object { $_.Substring(4) }; Set-Content -Path '%~dp0strata-qwen.bat' -Value $o -Encoding ASCII"
if not exist "%~dp0strata-qwen.bat" goto fail

echo [7/7] Installing Qwen Code skills into %USERPROFILE%\.qwen\skills ...
powershell -NoProfile -Command "$b = (Get-Content '%~f0' | Where-Object { $_ -like '::# *' } | ForEach-Object { $_.Substring(4) }) -join ''; $z = Join-Path $env:TEMP 'qwen-skills.zip'; [IO.File]::WriteAllBytes($z, [Convert]::FromBase64String($b)); $d = Join-Path $env:USERPROFILE '.qwen\skills'; New-Item -ItemType Directory -Force $d | Out-Null; Expand-Archive -Force $z $d; Remove-Item $z" || goto fail

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

rem ---- strata-qwen.bat: lines starting with "::| " (step 6 writes it out). Run "node build-installer.js" after changing it. ----
::| @echo off
::| rem Copy this single file into any project folder: Qwen Code opens in the folder this file is in.
::| rem Starts Strata (IQ2_XS), then opens Qwen Code when the server answers.
::| rem If Strata is already running it is reused (no duplicate start).
::| rem Only when THIS bat started Strata: Strata stops when Qwen Code exits or this window is closed.
::| rem Qwen Code runs in YOLO mode: every tool call is approved automatically (no prompts).
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
::| call qwen --approval-mode yolo
::| 
::| if "%STARTED%"=="1" (
::|   echo Stopping Strata.
::|   for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":8080 " ^| findstr LISTENING') do taskkill /PID %%p /T /F >nul 2>nul
::|   taskkill /IM strata.exe /F >nul 2>nul
::| )
rem ---- qwen-skills.zip as base64: lines starting with "::# " (step 7 unpacks it). ----
::# UEsDBBQAAAAAADV2Rl0AAAAAAAAAAAAAAAAHACAAY29tbWl0L3V4CwABBAAAAAAEAAAAAFVUDQAH
::# 94vEatWMxGr3i8RqUEsDBBQACAAIADV2Rl0AAAAAAAAAAAAAAAAPACAAY29tbWl0L1NLSUxMLm1k
::# dXgLAAEEAAAAAAQAAAAAVVQNAAf3i8Rqa4zEaveLxGpdUk1v1DAUvPtXPG05dKW1ER/lUBDSipaP
::# AxzaIg4IKW7yklhx7Mh2tt1/z9hJl4pDFH+9eTPzRkopnB75kmo/jiaJhmMdzJSMd5e0uU26Y9LW
::# Ut1r13Ek7Zr1KT2Y1JPGztUmcv4f2OVCbeX6ZOQYM8KoU90b11HgyVNvYvLhqDZCh24eUSRxmdDv
::# t58WgFOlD5Tv/myEBFVxdkZ3Og5CfDYhJgqzo6pDo5h0miPJeF/tlpPGtC19vd5fkZT5tirUy5X1
::# HQ69Y2sck7yo6Lxoeeh14gMHij1DcvLekoHkgzZW31ve4og6nXo8gdrEj0kJ8WmRWkyaQ4Cak1nn
::# Keh64Ka0nt2625JxhO6rj4B4pehbSxkXZuNz/gliR1EfKfqCANcmJV7jsYsT1+k/oVAYyTE3aAii
::# s2sYHuVCIK+ASrxRdOXRoXgGg1tjwTRBOnzxA1kzMEWuAycIqBS7AyzFtsnD1RaUBj7G7Xsal2mD
::# GhgOZpq4UeKtol/BJOjIEmVx+GmWkJ2ZROQNzY+WX1pwmkvEIqJRF++KKWjNqlNUtawRDKVUnmtr
::# Hk/ruveBl9222Fe92N98+fn9+sfdbZXH1hnEcUczopnHE0vvZ7HCiS7ZUuJCLVbqpiG5RxxG45Cm
::# VdRi0fZfftZwy5E2H1bAj5tKiXeKbpDvkBaZfV71Oval8pkJefbZmNMkpjn2SvwFUEsHCEXpxEYR
::# AgAAjAMAAFBLAwQUAAAAAAA1dkZdAAAAAAAAAAAAAAAABwAgAGNvbXB1cy91eAsAAQQAAAAABAAA
::# AABVVA0AB/eLxGrVjMRq94vEalBLAwQUAAgACAA1dkZdAAAAAAAAAAAAAAAADwAgAGNvbXB1cy9T
::# S0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUDQAH94vEamuMxGr3i8RqXZNBb9NAEIXv/hVPKYckZB0B
::# 4hKqShEt0AMFlXJCSN7aY3vJetfaWSftv++snbQVN3tn/PbN98ZKqczpjjYofdcPnFXEZTB9NN5t
::# MPvsu85EaGtRtto1xNCugjS2iC2hHEIgF3EftCtbzNfl9IHUHNapbZHPMh2aoZM21RoXRfWPH/W1
::# RUfMuiH4gFT7O8uUGMrOznCneZdlX0zgiDA4FI3IctRxYCi+L1bTSWXqGt+utpdQKlWL0d9Ysr6R
::# Q+/IGkdQHwvMDya2OLQ60p4CuCWZK3pvYWSuvTZW31tayBEaLSMEgeIiPcQ8y97lWC4nHMsl5rwz
::# PUw9Qjj4sDOuQQxESam0pN1ikwFQuHbcUxn/cys2GY6ooiqf+i49nB8nFBy1sUI6ilGZwu9gzY7A
::# VAaKjHmRk9sLAHmthKrRllfY0SMvPiFhFrRC4RHJY/98wQ9HaiRxYm7c6J4lfbn20dLaSsJDKom5
::# QGUKdsqTc1zXKN5sb7/+/n51c/erSHM2Zk9uhYFFK6ZvktyrROVEj7EeHYwIdFVBbSWLzjiJ8uhx
::# mnjxEt5xj1SH2flR8mJW5Nn7FMNP2avl8gS4TuDaFEBKsSVdwdcYepY8dLeSAQWFH6U5+v61mbSg
::# RYrx1A16MBwFp0/xH4yM9twINchUphFu59O+XxRHsZtxn2ofSlKpdcQV6J8ET9VKnnofxp8CFEIi
::# 8+zlQ47bqSqysquJWzx4pKR4c8LQarn+7Ynt6uUfDMSDFb5PUEsHCCp4ufE3AgAAxwMAAFBLAwQU
::# AAAAAAA1dkZdAAAAAAAAAAAAAAAACAAgAGZlYXR1cmUvdXgLAAEEAAAAAAQAAAAAVVQNAAf2i8Rq
::# 1YzEavaLxGpQSwMEFAAIAAgANXZGXQAAAAAAAAAAAAAAABAAIABmZWF0dXJlL1NLSUxMLm1kdXgL
::# AAEEAAAAAAQAAAAAVVQNAAf2i8Rqa4zEavaLxGqFVttOG0kQfUfyP7SSlSJZMYhEkVZotVISohVa
::# ZRXl8hRFwgsDWIDN+pIoUh6mZ8DY2MTEYHMx95uNARtIlnXA4H9Ju2fGT/mFreoeX3Ck3RfTzHRX
::# VZ9z6tS4XC5Hh9c9rvSQIcUdDPkVR8egEhjweyaCHp+3h9wx0ifWfsI42LD0K6YlmRq39mn18px8
::# CyeJlTu2chGxZFqFaV+ZVuSRsJXdEc94YcPamWLqLKOF2maY0WxNPWMaZVqMT+3xxA7TPjN9nenw
::# G2Wq9mJCGSC/e4IE9pMA/DPqCbr8yl8hj1+BZ1nxrHN8sGtizO3Fv0F3YDQAC8ierF6tMm2GqZTp
::# +0wvM+0cfs3tCys/y6/jjB6S5m56wOgM7LYLpMtQEeR3udyhoK+RCbPjA69v3BcKfC9HrM95nkow
::# mmd0ETYZq6qIfA3r7+UopOCRaYhqZCqMRmTIPu9b36hC3nmCI6TLhpj8IuG08kfG0scPL549eezq
::# 6/2VvJb538CxO44Ot384NK54g64RjzfYQ27dOEQ+kB+O3QLqPAH3n2OKa9w3qIy5PJB7wC15DPpD
::# QO2YZ0DxBoDsp30vHR3jStA96A66exwdBMAZDkAWpOAu6VUCnmHvXfISEHvkV9yjg7538C++BHpu
::# 4X4IrAz7/O/hzITfNxgaCHreeoLv4Z0LNeXouN1UlKODF6+t060e4nT+9PD5b6+ePvnj5QunU7wp
::# p4zUCaNx8+ACkdVACLR6laozGmM0ButuawuQztYZAPj3jeNtxF7ALBLeJjw6ayTmmA4KyzJdBzXi
::# i+5OwvQ809eYVmJ6BNeghv5O5Ngz9L6rHxiH4JpMJiXT0IRg+xPTYMMJaRFo3FjN85OPoGNGc9Xy
::# GjKu0v421UJobIpjph+CpuV+IxoTzXDIr+cZ3YGb1OPgrZgWYXSyrQ7QHo+twUE81dwMlU2i8PD+
::# 9zpJA0rSL8SB98rybEyixDe/8DmIXTQWt/nxUvUyZWSXGC1BXVblysotMf3SPF9hFHLmbISjp4yG
::# m/AyfRs7S4+Shz2kpq7wUgkq65f6w2zYGFCQDbrTKa0CAkujgEWbTTidPeS/MbPR0pKt3YZ9i3pY
::# rEOOXY2OYxuDWNfbHeMlzYUNIwLKuDQyX8DSGvSilImLDIy5/SAFBAwQssuG5Jm0sZQ1oRy6KVSQ
::# rAvQZgWL2s0+wEcqrdGSMbNuaSDLXYCxzoxIUC8MCMQEAg48n43Jspg+LUyrIjCexrsjWLvojfgw
::# JRRdRmTgDh+3zIWcMaNaW6CgnDkXNhdOMZ2W5BWwsxU+dyhttllAi/kVuxssdItSC8buqpUr80QR
::# TZ7mofGMvWPhZ0iSxJnpYZE90jiM6W4kuoec27rVzoRUIsiwtFloTghZvdyrlrCjzQ3IkIB2NXcv
::# 7AxqXO6spWNCtjf6AccI+ADPrEsy2vrUvmaDOliYX6A7IvdBKZCUh6eEMuUuKUe5S/sKux7UNqfM
::# TKF9Y+OuorFySHcEWr1wvwmCSnE+5rZEtJh5AFWCk8wguctaLT0vh4Oj4z6CI++HmBjRiig/Jaxl
::# A3yv2QjNoXOzFwCgZyPugEIe1zFtEcaFnLN1d8mSG8OxNCN8NGqcR3g83Y4an5tsXogWG1R3MX1e
::# SDGK406IxGZFBGsVVaHVdTHj5ZLomJYsdcspmMVJnjkDoHH95QSD0Uke2TXSx9gc03nQHSY8vUBx
::# qZRvnvJPcIFDcKla/Kyl+jZbegRuYrsRvvtfQBvmwiiyKszlum4udos3rEHT2qQNT1rmEZox1NRi
::# GcJpCytc3UX7kpeh+/WPGNK4T90o5AibOgVnxWEROQcB41OQoZ5m+oH4ToIQBexP4RrwvSE+Noot
::# 4yDSHFKSTxx9i1gujcuJSt75/KNBv6II2milelUBO6lX4SImTIqdGXNlEjPspmt6js99AjKN+VkI
::# ABmGfP4BhUyEAiNIztQR9Cssnj3v6gsEQgqxywNDhEle2RKfRkWJqvSAH1oXFDh9wWcyArM9Y/XI
::# yq/DeZxipK8XLcseaa9fverr/dnYom/6Cb/a5uWEfb7FnZK8fGqbEljl6ga/npIUMD0hdSI+O8VC
::# lgDbpLa1ZG0HihDjgc6LOQizJl69CItROCncu8m1TZn5t4Y7ljVkTUhVDEC4LjgKHlHj+EFD4zwG
::# vwnhaGERKi/m/4btbjRnHUBnLRrpryiYTAlnsUrFUAb895vWebJlXC2IyFpj1so6G23sdJJv6sKN
::# DjVTeZ74B9KQ/iHPmNIz5vEq/bZrG4VY+1HjCD2tWlLFdwdONNvE2huUbsjeJV2kWlkzU8tyIOH3
::# 3b9QSwcIw/QXUswGAABgDAAAUEsDBBQAAAAAADV2Rl0AAAAAAAAAAAAAAAAIACAAaGFuZG9mZi91
::# eAsAAQQAAAAABAAAAABVVA0AB/eLxGrVjMRq94vEalBLAwQUAAgACAA1dkZdAAAAAAAAAAAAAAAA
::# EAAgAGhhbmRvZmYvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AB/eLxGprjMRq94vEanVW0W4b
::# RRR991dcpTzElnctWvJiIktR05KCklRtKoQQyk52x/bg3ZnVzKyN35qWVi2lPFGkSiBRhEAqqI8V
::# opX6LzhJ6VN/gXNn7aQpkIckOztz77nnnHtnoyhqaFHILg2Fzky/38ikS60qvTK6S0tXxViSH0pK
::# K2ul9jQxdkTOCy+pbyxZ6apC6QEZTUIb7LR0+XyXJlZhRzwP2tlY21rfvngxLjJazoyW1MHJQijN
::# Rzt8eGjyDP9p+YVHeFk225xWU2qKQnmSY2mnfsjbEZLKyg1jusLJJcncyQkSS5ooP6ROWeV5fbhT
::# qnRUlfFSQ9gBtmofIYRHXZ+aUKHICaDrUrjKOr10Du8+W2pEYKdx5gztCDdqNC5bWQrLdCgH+KVx
::# yhs7JWfC2cBMKjTtyZoWmZ1m5XRFx2U0GheVdZ5spSkZKB/YrRxFbi9p1yuZ6vdp48LaOkURv12s
::# 52aAFfCZK3AarSQh6iKIG1KunE9oOfAyGUI00EhuKJkgY3JCIWIsVC72ctkEkndjarU+DtpxSXP5
::# AketFglPyX9IigSplWJ+5mRHAlrzDAlVnwoFTvXgfTJAMDlOUFo5VgbFcoZmTNfcabelRmO/E6wV
::# 6IMMnTIHxThfOJCws72+HRB0KHGlTF2n1erwNser7UAHx1vQKmOqq8Oz0vShKIWWTrb5IcjqhqKU
::# 3UaDiJIk4T9n6PD5g9n+/ZdPH872v6Hl1U/wE21uRuvrtLHR3dzsIfnqnhU6Hfaa4eTR749m+08O
::# /rh+dPdel1bZ7ygEHCGxSLkWsM94rK8tywtAuTBKL0SB7w6ffH3w521+iCiOY1pO+iqXXVY7IVi2
::# tlJzvvvoyb3Zja9eP79z+OXjw1t3Xv14e3bz2dH31w9//nXl4NnT18/vHkeanzh48cPLBw/r1VWm
::# rUd/Xf+WVtkqgSJHE6E8dx06pLdAdfv+q+/uzfZ/O3xx6+9f9mf7j2c3bqDgeRwnfVWeqgdtJTPX
::# BcmoGdZj2FAGAko9prGwLvAhPS3zLHLgI5+2cYrdOhZ5JR3GAZcejMJiQdDeQiT+e6lPyTtrVz64
::# tnlha+dqwsgHaixhGpFlXEql2YkJ4M9uPprd/CmJ6SMpS37lhsZ6ODPMmaL06GgZVHLoiLPcEZti
::# JMlVVoZK0Nc1Fh4GNZZWq1tXf75uBKGnc/O7uc/N54hZE4EV0MuWnJgKUy+zpsTQSEVVu38aAtdI
::# lhm+QFNh+wh4ExDB7HBPpSaT7ILMpDyP+piAOg0RirhGc9WLAcCA8kp7K9IRoIcxFfDHtG5oa3uH
::# nYhtKBoOdTBZDFla6B48Z+hCJXJINZJT/PZmJLVrctq9SuVZJxUpK135soJ8iQam3cJkFeLzlNrd
::# Ladhy+4uP2Y8j9o8txy6HaK5Kh2+wWZQd6ANEtfKcTFsjkBA/SYJPpIiC93NE67epfS/ZtZC9f9z
::# bPKm4Zpz0thKb09QVRsvaNImvkjUvGfDLkSYZw9ZlxeLi5J4zsuMB+w5ttP50LbwTJ2I64zWgAUX
::# KUahG6myXHiseTLR5/dGVNBSCseeXNloOXYwuERb2WlvKVmgcX6aQ5w+3JHW45RDsK3fYxyXAesY
::# BWOENBD2+JGiCs9qgGiLAZew8bShqnQeVi9i2gpdivGQyqi+li9xPrY7i8j3pA0KkbQW0bke5+F4
::# fAgEcgppB8HHVu4JF66hFb7bwzmkPsv6nyMeepghcxaGILhdg+S7Nvcns76+e8NHhHt7sqLW8HmQ
::# 1FdxMv9ASOLGP1BLBwhqdJjnLgUAAAkJAABQSwMEFAAAAAAANXZGXQAAAAAAAAAAAAAAAA8AIABo
::# YW5kb2ZmLXNvbm5ldC91eAsAAQQAAAAABAAAAABVVA0AB/aLxGrVjMRq9ovEalBLAwQUAAgACAA1
::# dkZdAAAAAAAAAAAAAAAAGQAgAGhhbmRvZmYtc29ubmV0L2xhdW5jaC5jbWR1eAsAAQQAAAAABAAA
::# AABVVA0AB/aLxGprjMRq9ovEao1Sz2uDMBS+C/4Pj4CjZWjxOupYp4516+iwLewglDTG6maTos/i
::# aX/7YtR13amXhCTve9+PlwfOMgkyTU2j4lhIRgvTKPkBFrQWLAMKKykERxjVBZYUbiG3M3riNk2y
::# ZAx+QeuEgy/VwqSoZMEhF4AZh31+4gKOpfzkDCGVRcJLp+u9qeie30GhKRx2SIBMLwvvidYD5D1a
::# vnjWt6vOeQrEas8W8TxC4M+7H1hdAW/yCoeymGl1tmtr7XalnWjlLSmBkWkAKMfF1YhBQAtUXAiT
::# nWmMe62+v31bBuHC62DkfD0LngPPvZS4WYWRavY0X4RW7PTEDJuvHONSSnSwwc7k5Aj++uN1vt5G
::# y+Xam16J7ekfZ6tQJXRuYMWUMVkLdP/Z1Ra1RiHxV2eLt1RW+qMoDluR6IJU9UgciGqhRl6hitHZ
::# URzG3/0MXwrkzTBVSPOyQgdu4Ejriqu9zxBclWE/iJ7vnPQPUEsHCGpXaqpnAQAAowIAAFBLAwQU
::# AAgACAA1dkZdAAAAAAAAAAAAAAAAFwAgAGhhbmRvZmYtc29ubmV0L1NLSUxMLm1kdXgLAAEEAAAA
::# AAQAAAAAVVQNAAf2i8Rqa4zEavaLxGqNV99PG9cSfkfifziit2qvb9YWbe+LhZCiSxKilqYK7cOV
::# 8mDH3sAKY3PtddpIffDuArFjwq/EEMAkgRBsTLDDDSEOGPhferw/eOq/0Jk5a7xOE7V5SE72zJkz
::# 88033xlLktTdFQ+Py0E2Go5HE3fuSKlEPC6r3V1RORVJKhOqkogH2Rc3JtIpxrUSG56QI+xbRYX/
::# VJ1trXl8yH6bXmROec8pZ2nJ9TOuv+d6zcxOO6UXvzeyKTjjH48GJmLhOP6rhlNjKVj83shx7RS8
::# WvUsLdZ4RvO7gQQGL38/cOPqVbCDu3bNRoFrD+3DFa7NcmODG5tcX7TW6vARDg1T0HBVOqYmw4Fw
::# dFQ4r1pLr7m2zLVJrr/hxhuun3CjwY1dOOy8fWfmC7S7bVafOS+m4KPnmnme0a8p6mD6NqS02DyB
::# rOa4VgFfLODGCBbX43cTYzL7WVFHLz67GLI+a+eZY5w4lVfWk9lfh3+48h/p+kA/HPqiuyucHEmP
::# y3FVGlXiapD1dNiyX1nLugcqoaTCt2OyNJ6IyjFJgQsjYVEWNZmWu7tiSkSOp6CEQ9d/7O4al9Vw
::# NKyGg91djKnhkRQ4x6JdYgNyShmJX2KDIspLTKDWg4bgUR5JJO+B8UQyEU1HVOWuot6DPQkp0t31
::# 2Z8I0t1l1k6d/Y0g8/n+cfnmtZ+Grnz/47DPRzuNglUA5GfsnSPETM9BkZqNVWdnv1nfg7rYawfO
::# 2QIWiNJunq6fP28g/uQS6s21Fa7nASuurXN9hus6Yb+Aa+1186RANSmijZaHda+zARsl503FLMyJ
::# olp7m8gq8kIpfMZ6/S5TBe/ozDTQxqV3tXlcaB7lgTpoD8bcqHAD7q9zI4trbZeF/Ehn5c69QAhO
::# wHldxGBvHjmVh56w29F6m2bGKlbM17Pm1EuulZuNda5lAZrWFwyb61nka6dHiNHMr1u5PLZC2xjZ
::# iETHBL/ysxCGNqaoUlL+X1pJyhAhduIeEh6gzuXPn09j2xQz5umMgACZjygsQxQht1Gpjd1mpXWr
::# YdHfov34mZWd58axtXZA7bXSgpgxJrFILJwEdFAsuFYTEoGXry1ZT0o2hrPoLZLIFtLDoLZK/8aN
::# jHau1a0HTx0dCrgF/ShS5MY2Nq9+iH9rNYr/OaPSmdoBcWayI5RWCrRVE4XHm0p5kQA37pPDM1QT
::# XO/iR32LhAI+AsdKZPAes53dsB+XrQcZZ+MRlM6en7Yf72NgQNqzKa6tmvOgKlpHAC3cIIKa221I
::# AefsHWnJqis7iNRDOGj/f9E82sYKk3IKZIOs90JRewmOqrVVdMoNc64GnQMcgDawXu4hi0TzYNwb
::# lAbks4AnYas60zyattY3oBrIJbfqVDpjmjLMBkgjn2L2Rk5kRgI7R9i7RhexYN4dGX/tByFoZVS7
::# oKfPh8fRM+guSrK5lQPmdCCy2zw+RvX3tirQ+dOaP4dGoY88FSGh1UUoMKRJUOwQDhnqVa+CkHZk
::# NGt509x7AuE06w/EeyLYZi2/tIqvnMpTLA+YvdrA2E82vdpE6lbl+jHh8Y4bJQRPq9lFTcBGYYZC
::# KJ/eZNiXff+FP9LQkDQwwAYHg0ND/SwgqIz9JoD5J54W9zbrGejeIOvzMKqKHZNdpwDcmtiFijn3
::# DthpTk+Z1ff9LpSgalbpCUg5wwYHL60+x7PEkH7cxHaBzXbXeDfp4g8CcLcBaMCOZDiHAgP8FSwA
::# 2s1Ptgmj1QRx3cYne25o1GQGGJDsQrgthcb5AgSjrQ3E3RxG4/f7yVRcZK3oCMebsjU5h7t9zjz0
::# RRnusXcOiPxZ0uj3UABne84+mISPTglCeEGB1EhvFwRf7ep9K5fpF8CdrduFFXKJefez3zKPWR88
::# PuYpcBwKk+9364s2I2IqYpHE+DgsAwzKOcq8vQCpeCaKYwipIDa85GjpOUUATXXRJdVPzzDIRzzB
::# jWVu7OF7BaAC5EaWyrRLB7I4aQGdoHE97Y/wtock0OMXQgBwrZXOl/JiwuLaI5fqWKs21bmxhDdS
::# Ab1PUvCC+pHxqF/+RWaBCEup4aTKenpg3Gn5az9P3mbtvxULp+ORUT8cJuu/yKtqvz0E9XMJ2eMp
::# SuivbsJXvHaeWTXrdRb6/KfhKzd/uHnj6vXvrnx+q88Pj1k6Kvto2C3vmdXVziBTY0oslrrVORmF
::# oHrOdp6kmijunQRC12KJ2yGapEM+X0A4+GBuDLRzJzmzZjexVMgJyKdjE/H/EBkYrZr1PBIxJMKX
::# eiUai133Ek7HF87NyYo5lRXvf0ekEfUXacxl9AeOLg63uPkvdnlgcACzgsut2ZdeWrpxtz7tmlv7
::# VmGZqPJMzIVcL3MDMG1YS/ehbUHoyLIqjoipBVj6d7L5GE/cEcd9qp/vmwsPPJFRl30Dbw1twDVf
::# 8Uzxa2FPQyAs7bVqkPHMzCd/TGA1AxNKZCw9ISqWe0TlL3seffYx6UZ+tH97lPKt5/QhxWYfrpIs
::# bQdJuOn3k/jx1FZfws9VWBy5QdgINvvtvPW0SG7+AFBLBwgbXORSYQcAAOUNAABQSwMEFAAAAAAA
::# NXZGXQAAAAAAAAAAAAAAAAwAIABpLWhhdmUtYWRoZC91eAsAAQQAAAAABAAAAABVVA0AB/eLxGrV
::# jMRq94vEalBLAwQUAAAAAAA1dkZdAAAAAAAAAAAAAAAAEwAgAGktaGF2ZS1hZGhkL2FnZW50cy91
::# eAsAAQQAAAAABAAAAABVVA0AB/eLxGrVjMRq94vEalBLAwQUAAgACAA1dkZdAAAAAAAAAAAAAAAA
::# EwAgAGktaGF2ZS1hZGhkL0xJQ0VOU0V1eAsAAQQAAAAABAAAAABVVA0AB/eLxGprjMRq94vEal1S
::# S4+bMBC+R8p/GOW0K6FttYceenPASawCRsbZNEcCTnBFcIRNo/z7zpDsblsJCeb1PWbIhIbU1qb3
::# Zj6bz2J3uQ321AZ4qp/h9evrN2A3Nx5g3Q7We2opzHDGT+t6sB5aM5jDDU5D1QfTRHAcjAF3hLqt
::# hpOJIDio+htczOBxwB1CZXvbn6CCGqnmM2wNLeJ4dwzXajDY3UDlvatthYDQuHo8mz5UgQiPtjMe
::# nkJrYFE+JhbPE0tjqm4+sz1Q8b0GVxtaNwYYjA+DrQkkAtvX3diQivdyZ8/2QUHj0wbQLMKOHk2Q
::# 1AjOrrFHepvJ2WU8dNa3ETSWsA9jwKSn5LTNiJx8cQN406EwhLAofbL7qW9qIvUXWmp4rMlT5tq6
::# 879eLCo6jkOPpGYaahyubeL8ZepAGeo/uq5zV3JXu76xZMp/p8NpLFYH99tMfu5X7l1AuXcVdIbL
::# 53EfJd9WXQcH89gaMuOOq78tDaTAB/wBbNXBxQ0T5f9WXyYJGw6lXOkdUxxECYWSbyLhCSxYifEi
::# gp3QG7nVgB2K5XoPcgUs38MPkScR8J+F4mUJUs1nIitSwTEp8jjdJiJfwxIHc4k/tMiERlQtgRgf
::# WIKXhJZxFW8wZEuRCr2P5rOV0DmhrqQCBgVTWsTblCkotqqQJUcBCeLmIl8ppOEZz/UL0mIO+BsG
::# UG5YmhLXfMa2aECRRIhlsVdivdGwkWnCMbnkqI0tU37nQl9xykQWQcIytubTlEQYtEd9d4Gw23DK
::# ESPDJ9ZC5uQklrlWGEZoVOmP2Z0oeQRMiZJ2slIyQ4+0UxyREwoO5vwOQ/uGf86CLRRvS/6BCAln
::# KYKVNDy5fO/Gq/4BUEsHCIhLbrSBAgAAQgQAAFBLAwQUAAgACAA1dkZdAAAAAAAAAAAAAAAAFAAg
::# AGktaGF2ZS1hZGhkL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQNAAf3i8Rqa4zEaveLxGp9WWGT
::# 27YR/X4z9x9QpTO2ZyTFcXxpKn/wnHPnxBPHzvguTdJPgkhQRI4EWIA8We30v/e9BUhJZ6dfEpkE
::# gcXu27dv9xaLxfmZ061ZKbuo9b1Z6LIuz89KE4tgu956t1KPbmrdGeWHvht6VfmgtApGlyaone1r
::# dXn1w9VKNXiS/t3XRjnzsVe64AZz5YZ2g8Xt0PR2EXvTqZ0Pd3NsEnvdG5X+q4vgY1T9EFycqzh0
::# Hd7j39ptjevxaGvvsbYzha1soXrbGoUNbIuP8bbVdwbnu6jubbSbxizVG3fv5SGM+vLofi944j4q
::# 79TgetuoWex9p/hKtb40s+UjuMBGjV0WfNAsLLYqdPJHHwZzftbYwrgIx/305vb8rDW9LnWvV+dn
::# CiZv40rN6Je5ep/cdtPvGzNXPwdfDnDLve33c/XaB1jfW7ed8TscYLY+7PFtd7QO7xaM0/nZF6dR
::# Oj+7hatzKGodJRLL8UQblfO9+mOIvdoEayo4RJ5GhrNU0Svt5BO81tbheMeQ0S22X8p5X6ifTYgW
::# MXOFyQdGHDk0Jirddc1e9V6ZexP2jGbn4RFBSC+G4WRfye+IUCYseB7A72rLCCBM2HOvSi+vzMfO
::# BmCh6g1hVpldAgRMLbnRtLDRHY7a1cbJ/ogfMFHUBEvERSu194PS2GpwcQiyEutC2gOoaZpk/3zc
::# VS58i7P4oIXdVbJzOiL7ORI5DwGjcOWZYzSbjCD1nXeVDa2CY3FL1Vhn5CyHjXo5xtPGoEpTaWQG
::# jAJCRrf/Wus+xSbfSekNElCMAFy46jXToULAoioDf+cwIDZqYxq/W3HVV0v1K5IN36jWtACXIAB2
::# Nkt16faIAt6koCjkvIF9WIAQbn2PqC/VVfK3jnfHXoDxszuDTMb1WovY/LYETJ8t1Y/O77gl12oX
::# d1ibgVj60+cSeFUFKywBk/sdT5/hYOBvJhGflfQd/4VNEAkGErdRpUWUz8++XiKvdGACcQH3rnUo
::# iTvSTD7BhjhyETiI2QAy29xbP5Bn6Iq5HFZ6Jjxs3WHr5/j4hGGARdMATRa+aZfIbrWxAm8alK1N
::# gK0R1TiDp7ZMnJQLERy7VP/Q2+FkS20bnHVBL3cafjQSnUKHgqsTjylwwVaokFyBdFyqVwPyuUxs
::# l/NhPG0E0AemaPr9hQII3v4ZPY80ktzUjDZ4MFo9BiwHnQSBRFHvcF7hXY9N0j+06hrtkrvTrmLG
::# K12Cyt6a/hFjY91dBjFTf6l+J/j1AIsqgFX4K/mv9fc8uLOmQJSXBNb33nOrD4NTa9cxqcDgSOE/
::# onc7s+lB826d08uUiMs6huJLbr7s4+r5szU3OT97Uz3ApcY92haxm6tO9/WceRyd7TrTzwE7tfWM
::# Ej2zJHWDcbCeyUh+wopKIU2ZS6OnkQHvPql2PZInHp0vEO5RrxBSD0j3SHEhCa6eq12wLIe5bCLO
::# jeX517qoZYVKxKngS1fidfY4IpFeMzSa0Jhl0nQz1e9QrsTKX6IRI+DpMU8YHd1nVqRxYC+ESbt9
::# 2vAIAiUdQrw5Y8qUNpVvcAoYyIL80nbWgR/4lZhpkDGA8yUKjw+9OBo+dTbWMH5jdJ/j0DUG95bX
::# eoOd8XF5hKPXAlDfZTquLOtpZdMVVTW4rDbiTneMHZA2Eu6QiwQuHBMSBFDnZ+v1WijyPXc9xsxa
::# yOyDAa4Lo9ZgVlvtbwVm6jGTJKrnz8iCF98+OaRVhk6iX6GnCbE8Wy0WAvglRUw6RAxI0MHqa5dz
::# lH5DGMHH/SfJChDpkbiBhMZUySuorSAZ9f7dtfqTzCVZEzKgpJ0nbQ89i+X1PWn3xLEznA5pFI/c
::# /wMWJJzUpukiGaVHSVF34EsmAuvtTrueTintFmXNdKCjQ/K+wzVWEovJIWsBUKeBmnw0Q0xWpP10
::# c4oW3QNCvnmoCUd3QF7AWyXcEcmvH5EvcZ4xdtg4owGVfSTl9JUQTzSdDpSh/xrIzycM9gOy8FHM
::# G30E/e5TGmuoh1zC4bwSGkmqq24iM1ETn7yfLPlwfXn107Wk7iBlA2oxvT9huIdH3WSzGojCXurf
::# eIBORxydjUpP/7dUQ6BTVzY5YATQS3Hk5XS99Cax2dABDOVCaCkXaz36eDWxZS8XiaapxnCLYJwY
::# ICk+KhnrRIHZkVLIFfEIjlT3oWJiMU2hLOekUb7HTSYqvWD+HTcISd9QOz2QvrCDNtc0Y7YzIvso
::# Z8hdX9PXF7NJXuC+UYtGHDfPWjeF+koU6Qfsu590rOQfwiA+zHG6OeytSFQrVG3IRg1fMrAl2Fjg
::# vtHFXUUfpI128HgztC4Rg2BQ+qyXx+UJEsYR5akisniwLLHCIrAeYmWI4jna96CnWqmklyBgO2pV
::# qSfyyB1khJbw2jZJbwhMU9yxxCRyH5W7pqp6McoLgZzTQVIk8S0uJTbByo6lcQrcN0v1/f9p1bjs
::# s0JIvUIlhZ/vaO3EflBcJzx0y75hJy5lx0ehkmrWITiXojK+uhgpjngV7sc1goS28PfCAdQhly6V
::# c+fZ+FS87oF1/rZUP/GYsTyVqXjnFpOrbmrw307SjD/wFtRzfAFs3cZJR28GYFiEG9awjy50d3S7
::# N4/guBaoThcbxX8up5NagtWtB0X63NMgVKdK6a3fYv/JolRVWr1FNECrd7Dnln2mMDEpuTT30E9S
::# A9ZfNvx4fXDCt3QCpefCVwt2HLDHpT7PhOCDhPQd01OgOfsFBayez9TsfQ0T5qk7uhX2isa0cp0N
::# FQ5wAy+2yxllPFxVaH4vlALyO3glbTjVcOlQUpEQCD/c16VCcOKQW5Mri+B/fVyGqQ9X7DxNwQA/
::# e/p0rtiEPH8KZfAdTVoBSehf4XCJQC20s1Sv7UfQY1mq9SUe+2D/nScErwwoKKi//keE6X/XY/yC
::# Efo9ePbvPKATgSfWX0juij9fw2mNlzLIl3Yszg4qa2y1YWfwYO9gGpJO+lj8F7RL/VrrI5uDxtyz
::# NmQp+6PJqi7jWEDC60XUdOmIcC/bSoSdPxKpFfM6nUJ+kdNRdlhWZVE2IJjpSE55qEZTVw1hiETD
::# /ntBJNO0tOx3yixY0Fld2Qhe2ec2/KQFRygCO9FIRI1P94g569iBq5MVcCdiQ8ZbHvDpW3vkjrRQ
::# NhoT3J00WkI20lHL0IRMZyKqosRZjHtBJpauUqYSlvtr3HAfLbtLAKEgcsHbuTriKepVaVkmFCqs
::# CTrpVlwpuYqBdJWMhkYdIk3cU5H4sEC3G2oLREboQ34VjReA4hI64m5oEEcYbWxZUvd0PIyDqe+x
::# RT8pASZq0nJMmDk5CA1N+nkzBPMX/njrvQBEJxWQX9/6UR2Ixpmk0zIh/HC22Bmnsc6BTVndRtoj
::# W0m//9tc/Z6k0z/RDdUWfU9rcNCn+/LW6U6fUaOUHQepbBrky2zSsYir6Fh5pLtOBllFo6nz+ew1
::# u/0qGBFTMDKdLNOGg94fBxmi20eQHrpLXuYw0DEy8tnA93mSMnbo7wHMYMsE4DwNSqgcJzi/TLjn
::# 3AVM1QAmiVZ3urkTyVcjF7c1qPQ6vZYKveeARCTYMXDi+Ci5b46ilOTXxpccIHHcFhP56Hg0XhMd
::# h9IDxksUyDnBwzYj3oE4KHuW0kJdARJBJpnjaEBpfqwer0OrFqFC2QHWoQW7ISJTsoxq7XbMizL4
::# rhPsAS2w/8lhtpZaS9mXpeBGV6bP1VUKPJzNAWqaFF2ZzQCG62zQjehTGt6g96DvGGeZM3K8in3Z
::# ESU3bQI5HJCQkR8YI4gyosAsfAkN9U5n7tEoOm13ENe4Qy3Dpl3wNO+SQg7wLq3eOtAyPHrUbDwX
::# 2dkoxMhuB1g9Uv5YNNR7Tgikhc44pRmTnk+NNGRVLlQsAoajBLpGZkyXickqmpXDSmAnaOr0cucH
::# iOjSSCt+jOaewn8+fSVOfpEUrPx1QCbqyISPmqmNhBRJxErQ7kE9NDHOwHc4Wfrm51KikKD53dT3
::# LmQE1QcACnKjiiwgHNKgNUism3u5NLNM84IkZMeddDg2HXf/5nN3zyqbfyWITD4qWTY844t017iP
::# IqYDGEtGCrQ6Jv4A0qVQovkY0MQQn6T5goOpiQ1GMc8o2kAtCttLf5gDcZTFfEArAb8ydLPd1MYB
::# dp23bKpPZ5Fw7a72UtHMR1OIyBVzOX5hIrQcG1pXWASDSXwh7SNFKdJRc0cGcP5JAMepfzAL1Lky
::# NQcixFKq8SFsnGeIjAR1GCCyOvKPBSRhKYXJOTFJ5HEon+eAPs3dn6UNJBcffk/Sm52Q+MtZKpVS
::# UWRX+RMHLsECV6Zkv3R7NdtMfTqyFzHe6JASjW9rU24lUUp4cUOpkCbhx7VXPZ5B5mBnKROSz/xR
::# SJJ0PlI87WdPsqDSsmfuuaFpWILJjJwaFyawtPfQC+I5Gd4gyNoNFNQDkVGQ1djJm5yvsNKW1re8
::# L5A7kHnATl0dNGTy41lhQ8FhP8iWZiG5EosTgME31Md87t00gka2bA0NHidbUylrhNma4/HtLTGc
::# Jl8raaEORM//xfHvOCez4zxyTMFMf/RIaN+n2vxYP0lBk+CLXkul/vHmyWei+TL3xXsjakrGA/8D
::# UEsHCCpbOCVgDQAAtRwAAFBLAwQUAAgACAA1dkZdAAAAAAAAAAAAAAAAFwAgAGktaGF2ZS1hZGhk
::# L1VQU1RSRUFNLm1kdXgLAAEEAAAAAAQAAAAAVVQNAAf3i8Rqa4zEaveLxGqNj8FKAzEQhu8LeYcf
::# 9tKC2aAebL1JKVJovagnEZLdTTdDdzchmQp78yF8Qp/E1IMUevH4zfzMfH+J15A4WjOIQhQ7itFH
::# +D3ezNS5SIqkMx9Wmta17zPHHNK9Uh2xO9ZV4wd1GZtDpwP1fTofahhGzg/EWNwuF3c3e8x2mxds
::# qbFjsld5GaZInWM8TP5Y4zGfTQnfn19I1kJvN6v10/Naz6uTaFlm79Ywjd0Jtda1SU4U2QxN70cL
::# KVsb2OEa/7KG4iEockYUTYCMf6wuy6gK5/T7XhQ/UEsHCLd0t4zWAAAASgEAAFBLAwQUAAgACAA1
::# dkZdAAAAAAAAAAAAAAAAHgAgAGktaGF2ZS1hZGhkL2FnZW50cy9nZW1pbmkudG9tbHV4CwABBAAA
::# AAAEAAAAAFVUDQAH94vEamuMxGr3i8RqZVVdb9w2EHw34P+wUB5qA3dy09T9uEMf2qT5ANwWqPMH
::# KImS2KNIlkveWQjS395ZSme7KWDYlkTNzs7Ojl7QOz0ZZ+j13QdqMyc/UeunSbmOeh/JbEd11FvV
::# jV19efGCPjhOytodDoWZkqd/buqhINysr/HN83eAZzeURu0ozUHTzZeA99r229a7pIzTHbEnk+jk
::# 44FJ4YcG6xtlnzhFEFRups5E3SYfZ6BcXnSa22hCMt7RT1T9/Ob9m20fjXadncnnFHLakWrl+bY3
::# kdOGXJ4aHaVk0oFx7SlErabGakLjrfWsI9eVwAdUDUmQK1y/xWN0RFFzIt/jf8PEmhnoG+JRoU99
::# 1HGWE8E71kVKhUvV6Ugnk0YSijV9BMxCj4DhfKK/MANqQL3fixKCLIBFGeXKa3gMsajFJVoitGxS
::# UeFlTXcosRQQhk4/pLXtpVbpnSykFmR1lnVDQaVxI32zMyHotDZY+EqhmN2m8JNRAXW5UBSscqj9
::# TU2/Fz1pyjaZrWhapljTH6jV+Ow69LBQoYBzcmIvoi9HC+OTp0qGLHapGLCvavrVrf144KB4G3X6
::# T2NfMu3gIEdSLxZEeDMnLWjf1nSfA4bMTEm5QbvENb2Fd3mRq80x4iak4bxqtcfoLMQXl+JFb49o
::# 4++MyaM0oxJWQF5Vjk86Yvo59qrV6MpYu/UBvgdxxi/cVIuscCXY3Nb0J2BUksPye7FMytHRVXUv
::# qrwSd92iI6d3xO2oJ0U5dDjcQW9IsKNGtYcepRb+3ubJ1dU14L+r6Z05akpmAjToTHhNCD+JmJ1J
::# TFerQBsafY58jckKE0yCGpMq8UTFHiAyzgrI39f0mzpItSlY4HTlCR0NG9md5xWSjhMqVHd+wO1l
::# q8swJzWYVnx4wAQ+xnlHLkxiMur0sfD/AcNaZInRR8YbCWhb32+hb7J4o1WZ9ZotvXmAIrBPhlHG
::# hTQeRGirNShgSo0Wu0YPjpO08WNNr1UAB07l+S22CEd3FJU7wFBWZF7uUSOrbPVRYYoyNgkrUl1n
::# xAVIp+UUzKAjLhE50iT2GinFrYqdcYPwnPZyAyszlyuYQo4Kf8UHFAPrcoWHM/i2ovrjGi81QBR1
::# xcLiAJmTnxATK7vzqYJyno8Tvy/y8X4NK4kUlrxj+F2VNRIy61ajh5lxTOJAq9iOkOvl10Xgc0SW
::# vEQCq1D+k7SUJlFQMXggv7gMMKanNFp2ZC/+Xxgu+Sb2LvH1C7APchKBGbMtW7MKtHu+5RCLafZZ
::# xKj0A/Q0bhn5SVkBiD4PMMHV4OUbYj2I4a8gJB/gO6d1B7+XHX2e+zdL6F/v4RR8UVLMSBjs0Bo0
::# kpij5OsVDI50mM4RwarXSSamYKUm6qNJM0CEooplIwSvyQNxMBF+uXJqHa1C1ExhzTHkw2SGMYlX
::# TxG0N9JrSb7OqMF5MG4f0wcVHj9E5Z4QRKhlpDtkQ0dmyD5j/84gPHrMo7Uqmn6Wcf0falRR/PIV
::# tD854hnpPNH6+ZMy+OrCPjAmfLSY+nFYDcL36hkGBu9guINGksntYrrrMulPn1Qc+PPny4vyQf0X
::# UEsHCDuVriuVBAAAhQgAAFBLAwQUAAgACAA1dkZdAAAAAAAAAAAAAAAAHgAgAGktaGF2ZS1hZGhk
::# L2FnZW50cy9vcGVuYWkueWFtbHV4CwABBAAAAAAEAAAAAFVUDQAH94vEamuMxGr3i8RqTY8xDsIw
::# DEX3Sr2DVbGWA7BVYoADMEdW4qgWaRzFLtDbk5aFzbLf87c5G9WIni59BxBYS8LNZVzoAsMdbvgi
::# mK6367CPdZZqLpD6ysVYcmMmvxdj5KoGslpZDaLUQ4JKGKjqIQeKuCZzpcpSrJkPJTjxOLeIEcMc
::# wAQWfBLYzNpULZIbgv8BmAMQ6raz9CG/Gp3b9r4rkthvxxOYkrwdL6V12Bznl3j8XRsxKfXdF1BL
::# BwgV0kJjrwAAAPUAAABQSwMEFAAAAAAANXZGXQAAAAAAAAAAAAAAAAoAIABvdmVybmlnaHQvdXgL
::# AAEEAAAAAAQAAAAAVVQNAAf2i8Rq1YzEavaLxGpQSwMEFAAIAAgANXZGXQAAAAAAAAAAAAAAABIA
::# IABvdmVybmlnaHQvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AB/aLxGprjMRq9ovEao1XW1Mi
::# WRJ+N8L/UNGzG7PLtjo9s9Pba2xsREdMx0Q/9DzM5b0dqVFiFToUe6Pf6gIKAg1eEcFBFAWxBby0
::# jaD4X+Zwqoqn/gubmecUoD0buy9EUVUnT57v+/LLrJGRkeEh/8SsOq4EXqtzft/UdHB4yKvOT875
::# XgV9Af+48nmnkeC5spUxuptrzFi14ku8us30NNMPnaUKb8c6Nznr4ITpG0zPMiPGNIOnQsxoMdNk
::# xgdmlph5zvSqVY0x45YZV8yoYZz0Hj/Zgvud9k5395qZLSt661QSdi3Es2dML3W1M2boTNO5nrNO
::# 9u4HNFb5YqK7GcNM4J1wmVfjneYib8eZXuNrunNe4amVTmMZIx/lHfPGihX49XtYiGlHFmEL5xCW
::# F5m+Amfh1byzH4ZQ4oDivBTtmO+e8pVlpmfE6Z77Xwf+pSr/9gWnlbEebMo/xJJ/Kn/qtGPjg0+e
::# TD8c/Pv3L2b/DGE+Hx6amJtamFX9wZFpnz84rjyQIRQK8ASi47vw+1iGfgDc+OYnfp5RR2YDXnVm
::# xAepTE4IooJzC+rw0IxvUvXPA58vnv84PDSrBie8E8GJ8eEhRQlOTM3DJk8XggF/YPbNQ+Un/0Qw
::# qPq9qveh8sPktOpdmPH5px7guxBUnQrMvYH3X80FvAuTQd9rX/ANPBtByQwPfTYomOEhZh4y85oZ
::# l/ir15gOUgHogPGo4vH84en33/704tl3P/7g8ShCTx+vI7x+yms7TK8w/ejjdRSAxmshoOsNa6PO
::# 9Lh91KSbUeWJxIbpZabf0qoMvEm5fKYAaXaxSZkMbt3fGNZVUcCa3mkddBoxKYN2zN4Owc5OAZYs
::# 4loIL6I+GlX+Hx1DRI/H3bQNovpU0nCnp2qPZ3BbqXE68/DQl7Bj5MheL/NkDfRKB79AQM1jp3yC
::# VWe2UJq5vL3XhLiAITyiF9KgEkrplBkNZh6IVXRTpipqYADtUr+0sJjzVq4iSui/V1rGzfSrUYUQ
::# SzhHdTr1PgQAwHkKbm5Zm1fW+Qass6/qzFh2btfJHLZxw8gBoOGU9q3TpnxNb/DIErxmZYHViLvD
::# X0eVu5qq8vABX87ydpjphZ5WurthO1sFxXVud+yNDDMreFozglUbPkBOkPBN5ES4lLF6F/OvR5Xu
::# UsI51CEeL0Z5fBOVKXAwAYdNZp4QGjUEv3hqbaTxInHazTRRDMWcnT8gPHfBR7raNvztAdXVUta7
::# gmsfNcIZ8A/Rzo9h580YL8VA2JCu8hIKVVX+8sf5l4pgCT3QfYFHWshDcpO309J7y1vd+JlwP9eB
::# qzzeFGAyfZ0K5dh+H+/qb3vuLYTTT5Di/16xxMVCIQ14am3W6TrUwxEXAo5EKxQU5IMJiLPC06Wm
::# yNN+byCW7o4yEz3eucmQbA6ZYVhpOGzSxUmChOrW4mDsPQn3HV6DIzSISA2xRzj/NgpGA6XRzaR4
::# NIECgWVYBShgSAK1RXGhWjUDI7fDUBOdxglFK1vZBjIDjeA2Z5+s9xdB2ugJcNId8ofSJ5YQpxpq
::# ywNSCq4VgGpCohYRkxXQ8bl9uS06jsuai0zuHb9Zo8RDtCl5kR6nrJP0K6sMknk5P6Oqr5THXwyI
::# hUqDECU+7zEPNXyP/J4u3ZTj1s5Bb/kjnv1ViJqoHPDa36UEn91xRkwcGL6i1krlRFIlYHZ7KsAl
::# Mmc8NN+94KkIwqbpdrJtL1+KZLDS1q/4Zuh/dO++Q0Ej0OJijQ0JIUZpIrrkauGQKjJE62VRIo7G
::# GjnLObFGTQn0SXFAsTxXp1WGpOxdATOLgg1hQvwWMtjmWsbZz7klkOl3E5Dn/jZPgMzSHs842Fsa
::# vQXs2iiRvUT4Yph8DuC9Iee7IgtalJaG11FmnJC9F1B5cBPwqICGbu3shbvZl7gVM3WMK52r54ol
::# 533dyrewYyEbztEZaM6uLllRDTMWqQ+YKFVFQpwECtLKaZ2bt193WpdQdjRUKCNwkBQz6pAedvbw
::# ByBwXOF7pr0R51oRiTxqCu9G+g1A9aSbKdpV3P+7gF8d8y/MzGBr+DWGNt1IdBqas3SBrtKO8SJ6
::# t5UskKcB2SCIdG9fiQyscS7PxxXoYH20sN3v4RABbh1Z5GcpuLA36rzRsM9beNPNUEYTIyNkDmmY
::# qxJdTfcGJueDczAW0ZCJpwDLd8rXdJYyM49IJwUCukWkNeARtpTiUl9FsHblhqcSvczv8ziufP/s
::# 6TcvnuGYYuWidqhAtg4dMQRtkvp+HjqubJkDqnCbaBX817mOyg0GB17AhUZtdwDAeoIaskOXyO+p
::# Qc0wiq3SiAkkxZtAN82hE17vmNf3WqGKJuGLgWx+4eex2YWZj7gpzAM8VOHhCBQCTSWoCOW3xdU+
::# SfRPgCwf3MeAbg9mLobCTuMQbQSbzLK0JtAf9h29yOtJGi2Sbv2TxbhbjjFzjQYknHYkbdSTRBiq
::# XtlF3JlDVoAe53WAKiF7HxX4I4QL2jDZFbipqKQB++77/sDcI0pyRHLwac3jbJit4jRotpzDpH0R
::# Esmh8IkSXgSjS1plyLUCU6BTjsCYYmG113AEM5KiA1vJlFWIUMfAE7refuwghtm+K6J/V6PgMYRm
::# lUcuYUugTH7KQTc0DOljVex9RK88AAIgB9oNGnfzcqwFE7oMi15pg4PvL4vzwBm6Zhm+wsBjrbUE
::# 9DvSxhKVyS2PLoMPQOq/BOYmVeXVwvw01dg7HDWRxTtF1QX+bwtUdR+IXRjPoDmBO1WZUaQuL0yS
::# ei04W+Wsu7RiZ5r2ep50VBMVhGDo23Ja7LeLEcUubfHaomWGATph3uhYUGlYxHlMBckaHOAAE6mp
::# EkmlgsxRj+4x5I4NVStdxqAuK9bWW5qXMneIEaMSjYNykAK8BqYyaLOSDvkNo1e/ookPm49dL1g3
::# 659+rcI3jDskw4z5i29GHYevPBXmBhwz+md7/g1+lH9oDczgsmuJ9t1p4rAN32+/aetK52YDaySG
::# pceMCH06HfdHFD0mu9DgRCCXgknbOxqUFGDb1dZRcUghnhkbDHVU6AD4Avp9wvUXj0eQZqcW7fVT
::# GWzwE+HO94H76dX7K0d3APZtnmd3h4f+A1BLBwgawnXNBgkAAPsQAABQSwMEFAAAAAAANXZGXQAA
::# AAAAAAAAAAAAAA8AIABvdmVybmlnaHQtZ29hbC91eAsAAQQAAAAABAAAAABVVA0AB/eLxGrVjMRq
::# 9ovEalBLAwQUAAgACAA1dkZdAAAAAAAAAAAAAAAAFwAgAG92ZXJuaWdodC1nb2FsL1NLSUxMLm1k
::# dXgLAAEEAAAAAAQAAAAAVVQNAAf3i8Rqa4zEaveLxGp9V99TIlcWfqeK/+HWZLeyYYMzZnazWWsr
::# VanardQ8ZB82ydPWVkm0o1QULMFJ5o3uBgWB8ScogkFnVFAi6Og4CCr/y15uNzzlX9hzzu1uWpzN
::# CwXd95577ne+830Hv9/v9YQCs8oYCz9X5kPBqemofyocmPF6JpXIxHxwLhoMh8bYh0ZB6+c3uFrh
::# aoOrJ1xd4dol12+4Xvv1JinqmW5r0djd77avfr1JcW3dyCyJ+g5Xt7h61Fs6EXfp7m3JODzlao6r
::# Ra6l2WPnQMbVuhPNTCV5TDO2XonTbXjevdvt78HztpHq9E6yZiMuim8wjZjqbIFl7gTw9INSr3oD
::# y4xWjKtlrha4egc/rRy0dfMKcluDIH1100iuwu1oQRlvp+e5fsp1nWsNel4Te+dibRmDaGnI7Vno
::# efgHhf0YjE67LkGosb85SX3O/tC9S489WCESVa4vcu2a60lIpB+DRAofQdgPvZ7A/NTCrBKK+qeD
::# oegYezSIxijWe/eyxywaiPwQGZmdZPAQ1vT1qsSD/bvbXO4XVtln0//5/BGUNBgJfDej+GfDk8qM
::# Pwj3mAjI+kbnFxSvZyY4oYQiwIWvnn3j9cwq0cBkIBoY83oYHDEVgYy+WIiGQ+HZFx+zb0OBaFQJ
::# TSqTH7Mv4WKPcBWEU6bC8y9g5dx8eHJhIhp8Hoy+gHd+JJrX88EDmnk9XD/CS2pX+Ins2uBahqtp
::# rqW6zawoVaEESDkC31X0BvP5fvfFv7789qt//PObr30+eOv1iJuckTvjasY8btGm1H2mNHgsI1bj
::# XGtThd9xvcL1C2CQUYcDO4it1gAYiTLXQF6JpF38LFchnQ51QOHegTU27oA9DjUZnw38xP76ZHac
::# 0eJjPMLqIbicRlc8w9zUXfwOhaunoHYyBp1i0Y22r8n19tsG+8wKhikArB+wfj4tKml4ir9HR9g4
::# lE5hf/x9ZJBAxVkjkm08cSUv7rasHq1u9zNvnEO9nk9G2AA2bR2wlk0lVho9/RZCulvO54NDakax
::# ydWssVLkanIoJGgEMRjQHw/NzbKoEoliYhmm/BSMsieILLyyiYyv6kbphOtQu4rsxf5ewizWYQsu
::# RpHBLBljfmYU88Y2CNMJEj+5SEVWbRrdkWZZOiIWE6IO3QPFh9gAfBM7Cb6r9d7RinkZl7QzSjGu
::# aeLoUNxCuU56ldf9JWo4FS54YRUNttjPbYGoGdsv4daD0t1jdq13cSJyKxJv4/QV5gb0xOLE6TJP
::# R9iwjg3kq8w1lXTyLQqUi6nGJcSLiyWgewFgdl4Zx2Uq1IBtoxLCURKQRURVh60Vs9CGOtmIEplA
::# vc2DlsWkh0cCAtBu7wPYEWp44mi1zycdwNwBfGujeDUVlOugH3uDlxoQjhrz3mHiLoPdb4veY65v
::# IB/1FGq7JfJbkM4QbmIx66aOi9aIcfLY3Kw6PHZY3queomXpbfg0SmXzVQvugYjigbBgC7qasjon
::# 3hxayowPhyDHdkM8yaaEWqJiA9RloLSlJ0P6QylDe7oy/dMI6+3D7bO94zNC+TWRICVW4eG2kb82
::# LnLoZNdnXFvudTbJWXfwwOShJKdx3rKWqU2RXIJlRrGDvUknyDji4NzIQWqZp6L4M7liXB7jsPxh
::# +budXTNXwLaRTqQ2zUrb1sM/A2Hu0b4uEodiuSjuElzdd6Tc7ubGg2A1WI/Eiqnddh6JZXv2fbp8
::# OsL6S9nekYpSdJASmTyR36qltHVq9IGbY2nldeFL9rxfaKHKHJTM8iFVaw90FjwVfjpl6MdWjV/2
::# 7f5uUBWdfv3LCKji0JEilcU7Alr4EAtrvtVID3EbmRQ60F0CuNJtnkpHIeGMo9l0Subp5mAT5ABO
::# YFWCpq9h38rYQkIltTDOiE5CIgOFZOORGUWZY58+cTkBrQRCHUnB+//9QnIA2bjGuyTluiNNehT6
::# GDWEVli9KNHS1keBUhJVW51SGNAPqEmwfL6xYcVzfPfBCIf9gxWRMJMu9Dq3YnnPHiwH1cGJdENF
::# uV1dA8tEvxwfzGFkLuL2WqQc0cOU3EzBxGggWH5PA6CiWkk+JC+J7TIOlhZbU+TuzvSbcfEHT5WO
::# LpJncC88VVq0VZV7E0HGfJvpqy8dIIz8GX2POw2CG9EkdoYGVquKTji8fvIK3A5wsmZzYCIYXieB
::# m+tJMmyrVjCJo7FZop6jqpctadfWe1cJyVNz71K8XkaFxybLoxOvrkHljY0s5EcqukSi0BEpuM8B
::# IPR9eH5CYXMLkWkkTeIXlD+gur5PNWjT6mYfZKCzTzPcO9u3gFFNqssBdRghL+eUmNo7edNfWjML
::# LXOzTE3dEPUy6ShMJTtWvQbA+NmwZEBcy2tr7llb3Jxb4gMOVypD/4jYAfJVX6HtUOYL64uMDssk
::# g2EN8ubU9lt6i81cfSAofmZWtkVj0dATUEI8dakF0okyhtHLFCI5vMfpFPAKepGWXgGqaBQv7WkI
::# pdzYqv7GtHK/2fGfT10upTkAMCTBrplvV42fsaISMPQ/V+fATzelqQRVyVxrYoWJheZEyMr6FwZ9
::# 1D7sNiHt+lORadEIVzHP9o3bzYf/vmBGsL0DRu7vgzPK2EwwpEBTa3E3Ss/+jie9azt+Z00zPp9U
::# nG4LPQgG1//GNln3Noeqmc7R/1pAeNEyKmm6anroP670DUBdgkEamKWW+QRPcP+XsE4A5zd3Y0YK
::# idGPbWLDIYMRZIgNHoNO16QFg2BPMZjkrLm6aG6eW8HcBnvPXe3py/lp23tdvCyL4h4xYZlueOH+
::# +ywnWa/nf1BLBwj1DuwNJAgAAA8QAABQSwMEFAAAAAAANXZGXQAAAAAAAAAAAAAAAAcAIABwaWNr
::# dXAvdXgLAAEEAAAAAAQAAAAAVVQNAAf2i8Rq1YzEavaLxGpQSwMEFAAIAAgANXZGXQAAAAAAAAAA
::# AAAAAA8AIABwaWNrdXAvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AB/aLxGprjMRq9ovEao1W
::# XU8TWRi+b9L/cKKbmDQWFt29aTYmRtddsxGNulfGpBUGmAgtYaZuvJsz00JbygIiILbIV2mhSAF1
::# WaRQfsyZM9Ne+Rf2fc+ZKWX1wpt+nDnv1/M+7/NOOBwOBuKxESVCRtW+58nRYKBf0frG1FFdTcQj
::# 5Ip9tOss7DK6yOiKfVp0NneZ+YqPT7UWJhldYuYkM8xBVSeM1tzcoZOeZFb98f3b9+HLrs87lTfw
::# gOgx7bnWNdIPh27hE89OwSFfPeCzOUYnmZllRp7RbUbnGK04u+uMNhjdgID41JjCgI1tnrYwC4O6
::# 0w1e3OLFfTh3VyC1abd0LBIs+96oU6zyWt4+HmfmGTM/M3MP8zt8yyh6w0BmXkSpwLndWG6tnkBu
::# TvasWcXc3L0UL3yAp/8r9G78ReK5Qv5S9SHSLfEiT5j1ilkfmZV5CjeuBAOxscHkiBLXw0NqXI+Q
::# S0/set1JTUeI72xRVJZqp8ZnICn4u8ssyGJPfGafXoJOqFrs2bASHkn0K8NhFYL3xWRb9LGkEgwM
::# q31KXIPW3bv7OBgYUfRYf0yPRYIBAogPahD7oaJBLlfJrURcV+NJVX95lTwYS/Qn+3T1Bfy7hHfB
::# qTKYGHsJ90cvPgsjO4KBy21uBAPfw4c2IhESCv1w8+Fvf977tffxo1Doy0nG3YZeVaFLPL1ln87J
::# jvFMSThF+y8nWRHzMunpIp299jkgL2WYVUakzEP8pDvNj1U+Py2fCoLtNCeqPDMOTWxWzxj9fO7a
::# eb8GPXaykHBexM+Bd/uo3FzLSxq568eCB145fPcNJCEeVUXfTDBndK+1UWB0H68ZJvoNE8Hgmn3y
::# trl9gBQ/2HR2PzG6BYxsd/vLyTSzFpm1DRA52ytN6xST8fnaWk27hRr6iuJUaXpMT2okrD2Lgg9x
::# NJwYJOFwIq4Mq3GFhHt+bD+By9oQGVY1PSpHgJnQhBVmWdAK/m9NoFFzymazTEUEnFOYyijpht83
::# H/3xyP+jjSp9Wnco1O0PbpSI2rdlqsyCciro19yTCUM/omHyhDyNCozBd9dQLN6fGBjo/v1m7+37
::# d+6gE7jFM5sPbkFPSLTbu4Cu807Nmwt+Mg8z6h4uMfo3s9aYtY58oqaY132naPBUlaczoqvAPMML
::# 11YV8Jt4oYzF1cEhPUp8jZGp7wg/0FERri0MIDBG3j5bdueX3Jlx9/UBnKBPXjpw5hd9YUmhpTWO
::# NhZwr86sOWbtwKAiFTvz259GdiDy78QQZCFXSSiPfucDISrPT/Aa6NK88CADoSukDF0Wv3daC+v2
::# menxUbIPxsEDwiOpNzPXLs5Mhz4uiemtb9pHAPUqo7MohBgEKdtaxUHhE8eSzYCle1pDsaR7TuEI
::# h0RSX8aJRqPBgJz5CPnFV1MxyJ1C4CNMeuz64Y1goJ0YGPUSOAMtIffwh+Q+MA8BbGDJ7j8A6bS/
::# BSDFLXAg2pYD66/lXViWKj+DMyhKYgNFgZHsLObZIRg8vclzhbbk80aa0TWBK6Lb2VJo2g2vYgHw
::# 9S6CfUEBgPXR6CzY0wAj7x0aqEICvhRUgSAIDgK1Z9xlQ+iPL5hgU4HaqHAKF0CqVoQ9yM5ek767
::# 2AHgu2cvuGlmRASUJK+h37Xcah27UfDBMOUjXlpoQ4FC8i2IcA+vfuIbOfdtCpyDScva4jOz6Ac0
::# Ym4KdgOOezbXWirBhYHEWJ9CRpPaEN5Ov0d8rHrLoPYZDHm9Wf3QmpgFrEUN3jRKAHnhndz7vLbi
::# K3QHEggrkoVmEEr6WkC245SKza0TsSW8kRWy2x7ZrHTpbYJvvCwctYwPIC9ekAu7gubdlYJbaJwr
::# Ay3LjuM8mq+cg2PsJLyHYBswVQ5IzWR8lCk3lpobRbh5jRnF65C/k4eWw1tJuUesMLzWuc7Op/un
::# LsLzxzwzIfKotN+ixGj7yxhfoDD+pIBiSrJCVspP13HMPVXs8A2rNhSSIIRCERjJHMD+9QyizA+o
::# w0oEdw8IN761nK+Yu7cZLUFEoXPX0KMcWPT4NcbgSyZlH0kut02vo6mkgDCV9fgiLDU6GPgPUEsH
::# CLYN5IkCBgAAugoAAFBLAwQUAAAAAAA1dkZdAAAAAAAAAAAAAAAACwAgAHByaW9yaXRpZXMvdXgL
::# AAEEAAAAAAQAAAAAVVQNAAf2i8Rq1YzEavaLxGpQSwMEFAAIAAgANXZGXQAAAAAAAAAAAAAAABMA
::# IABwcmlvcml0aWVzL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQNAAf2i8Rqa4zEavaLxGqVVmtP
::# GlkY/k7CfzhpN2lCFim2/UIakybd7jabXrJ1PzVNhupUJ0UwMnbTjR84M4ogsNp6r1rvoLBCTW9U
::# UP9Lz1zgU/9C3/ecYUDb7OWDI3PmPc97e97nHL/f7/VEw0NyiAyPKLERRVXkuNfTL8f7RpRhVYlF
::# Q+QS006Z9olpFaOaaOQLTHtpjhfNiZR5lG9uJBktNTb37J0jRpeZlmF0g9EXjJaZ9pbpr5kOzzRL
::# aEb9VWP/kOk1F83aX2/ox7AyoKjw7L138x78M2rzVmEJ9hM1HH8a7xrqh0V75Z2ZzsGiuXFovphi
::# NMO0tLVaNMtZ4yjpIkJkzRV4pSxBz4VoVPOMfmI038hDiCsYKMR0vGrtHjBaMQsZ3EWLjI7D+u3o
::# s9hTmfyhqIMk0K4LeWi/f820qcZJnVFwecD0OtMr/JkmYyQciTyC3Ze8nvDIwOiQHFX9g0pUDZEL
::# D41azRqfDpF/AgggAGG0YE7sGbUPoqiPLkA3lHj4cUT2D8X65YhfgeD6wqI16sio7PVElD45GocW
::# 3rnd6/UMyWq4P6yGQ14PgRoOxMF/L5byR3LfSeVPvh3fY/2jfaryTFGfX0BzwJUHYiPPYcvw2W9+
::# JIrXc/EMTbye/0eNhGbW5635NyHi8/1w47eff7/z093eBz4fIvl8jM6epw2ttPZzUiU0ps8zbZNp
::# O0wv2R/3sNvIKDBeZ7rO9FQnwRitAqC9lrDS0HMM0UxNMrro9tnnI43iqbVes+f2wLJRBC6cmtML
::# 0KKzYXDv2kvj+JTRJGzkpbhIgl3kO9zTMvjZ+nsTILnnLOfrFAJU843NLA8hb28dNYq5dmUOlszV
::# vXZ0mobFoJXm9gqjb9BMuPUTUSdnnmAkDnetg3eM7gHp3Wi+1KeZvsj0fcjAmTMIpjUwzY0Je6WM
::# WBLMHomrYXU0TvzxxxJg8KVIbID4/bGoHFGiMvEHL7tfwDg+SCJKXJW+1FMAea76sEKGR8EEYxTz
::# Bam0WyJSzAMLGE1B6l/qaR4Ijj8MuwRjIPXeePDrg9ZLfFjuiwd8vkBLDyTCS7QvMmI6ZF1A91pF
::# 5AVhSX7ykDySWthdg+Fof+zJk8AvN+7evHfrFoKgVcBZR8QyUJPRnP1hmdG/mL7J9C1nuys+RArE
::# nskjUWVgUJUgVSkwrPQ9HR2WSEuWyiyRtcqZdrqJHKwYp2v2PPQvh2jmzqE1v2hUD9BaT6KdYK0+
::# C5zmbMtit2kBpsdMJZE7dBsqxkmRRS5An+ka/tY0c6YkKAfpNCdzaONi0oq1AEVeR5zyeot3SC6e
::# mNfTHkGCTs/KEVpq6bYvWmoubBmnmkPYdkOF3Je4smXas9HdRVwpQObXlvgM8dkwqo6EC40Qdu4k
::# oAVMls93P0jM7SnuXGSf8flC/6GAELM+wzRRqBovYLlzTq2DLa72DqgYNa+nm/vsJs3EHKCjKyEd
::# VjWFas2p/a9k93qucJgrxEqfwnw7m2kBTAUcAhsna82NOgKcMWpH6fVc5TBXiTX3yVwY54nP0sbb
::# ojnzAsuH+aZ5y3Y5Wd86AfFZtzKbZv09cjqx3Nhe9XquIZigISIxPY9N1j7A05zYNadW3FDMkwlG
::# N4FNZmrXeg29LXQquEMccwZastRuLySP7QDGAuMpbBCTALNoltM4AzRrrx+0VQ1OCex3qQWaCl4G
::# ppPPyZek2/0VtJa15sIsuAROOFA0K1xzGcm1TgXaeSoArLVS5fQCy3XBMJdbGBt4n8R8+FCX8Kow
::# M/5tLq5Ha2myBVLsmEQgVeachDvMBwJ01owXLJ2zj8s85IoTXesMEueEebzlnjIiOgdPkiQ4S1YT
::# IsAQuR6Eq0EP+ZyYI9ftmaQ9d9hDoIAiWnJd1KzH6dMYuQjXEjc3+O0SDNfRzz6eJloOXh2IMdgG
::# h/03f4gWBLP7+Ojq6oKn9ESJyCE8IVCo+2JDQ3A+BIg4meC76OoYn3jOPQjfDcDJgfNt+9ws9jh5
::# o15yNpWcmvATEauxU7gGdcDylfnRipqpteQxK6ae3CVgw3W+4w4Hdyypfcni7IKu7AW5PmIHrI81
::# cTIB+lmFJJKzGZVR7O/olZ+0KANDkOW5C/l3iMz9APdTeIWAjCY+Gsez9qtxgDNzS8ZxDkUCuTHt
::# wHVobPYyZusocvY7F19k0+L5TM4QCat2gjKO30NEEryDOxFIUog4JxkQqEW1jkbhNHDpgpZ8BVBL
::# BwgAvYGtdwYAADEMAABQSwMEFAAAAAAANXZGXQAAAAAAAAAAAAAAAAUAIABwdWxsL3V4CwABBAAA
::# AAAEAAAAAFVUDQAH94vEatWMxGr3i8RqUEsDBBQACAAIADV2Rl0AAAAAAAAAAAAAAAANACAAcHVs
::# bC9TS0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUDQAH94vEamuMxGr3i8RqbVI9c9swDN31K3DJYt9F
::# 6vUji7N1SNulQ6/dTYmgxYYidARo1f++IOU46l0nUSTew8N7aNu2iWbCA8w5hMYiD8nP4ike4O4Z
::# ZRjBRAvOsLSO0mKSBRkRhpwSRoE+mag1LtEEXhjyzJLQTLCLeMYEE6YT8gMk7A2XAyWwngflYQg0
::# mAALpZd9d9e0KqW5v4efhl+a5tknFkg5wvHkBViMZIaW+2MVVC9d1de2s5bhEXaLlxGW0UhtzSOG
::# AEIUwDOYs/HB9AH3XdN8Tj6e/jdHnhUAVhmgkn3x8jX3injfwTdXEdfK0TBEus1bJpwpiZYYqQpZ
::# aO6aDxWnWouEoJX2sm2yi6S9cfTR7h+AzQWYNuiPG/RaVR8LyIzK9fBmUIlPrXCupRguxw5+xYGm
::# yYughWE0UWMAkxCcjwimmK8W6LeALSFX1oQuMz6Bd/V+/S29B6OHa2BoS9IL5WD1BUjNXlJpFDcu
::# qLUUXfCDFKudD6X962DwfU1IDI8Fwyjbzbj2uarumk+vNhTTrT+XnbKw60kTqj5U5puNluosdfUK
::# 67p7Hfx401ZR766WDpSjbNQ1j7daH4FiJZGFIKh1fKgEeS75WUhFIuyOFGzXRVyO+8pTSmKeeh2S
::# HOg9rGHwulb67FNhbgslcO5/46CPu8n8gUcdYQ65CNJd2aT4jysq1WviczEvStf8BVBLBwjOR+dO
::# CAIAAMkDAABQSwMEFAAAAAAANXZGXQAAAAAAAAAAAAAAAAUAIABwdXNoL3V4CwABBAAAAAAEAAAA
::# AFVUDQAH94vEatWMxGr3i8RqUEsDBBQACAAIADV2Rl0AAAAAAAAAAAAAAAANACAAcHVzaC9TS0lM
::# TC5tZHV4CwABBAAAAAAEAAAAAFVUDQAH94vEamuMxGr3i8RqdVDLTsMwELz7K0b00ko4Eo9TQRyR
::# uCCE+IBuk01jmtjRrtOKv2dd2lIOHGIpOzuv9d67SAMvMU7auYa1ljDmkOISV282Qu4Y9STCMWMt
::# FGsbJYSsmEbNwjRgrnz5a3CSsAkRocUQVEPcLKor583LzWb4IN069xxEM2SKWG1ChmbKk8LreoX5
::# PuQO+44y71igHfe9qaYeQUE7Cj2te14Uo7rjenvIeMxWdLhy7p/shtxUeGkLJAyyL5pKGobSiDqm
::# Bqk9d7mG0hc0gWJj0mms3O2JfnLsyIjxgnLuVE66ekAqXvug/BeBn053evyRelpV7q7C66F1m6Rm
::# XxbPhgeWnUD4k+vMDeYxRd+SZm/be5JmYe48JsmHfRZJchH9vsL7LyqsU59h9iky+mDP/FipUIqZ
::# Wdhgw4vKfQNQSwcIiijjNjoBAAApAgAAUEsDBBQAAAAAADV2Rl0AAAAAAAAAAAAAAAATACAAc3Bl
::# Y2tpdC1hdXRvbm9tb3VzL3V4CwABBAAAAAAEAAAAAFVUDQAH9ovEatWMxGr2i8RqUEsDBBQACAAI
::# ADV2Rl0AAAAAAAAAAAAAAAAbACAAc3BlY2tpdC1hdXRvbm9tb3VzL1NLSUxMLm1kdXgLAAEEAAAA
::# AAQAAAAAVVQNAAf2i8Rqa4zEavaLxGqFWVtPG0kWfo+U/9CavOwiOVb2phVv2SSaiTLSZHPRPkTR
::# 2oFOYiVc1pfM7Ju7G4xvBEJiIEDC3Tb2YEMghNhg/5ctV3f7af7CnnOqqt0GRnkxdl+qzuU73/lO
::# EQgELl8aDY/og1psXB96EYkHwon42OjYyFgidvnSsB4bikbG45Gx0UGNWUVmnTDzCD+NPEvm3akK
::# b+WcD0k7k2PJaWaU7fyUs9VgxgIzVuEnM+BitXPadt7B9/fMhMfM7yPxHxJPtPuwn3YnEteYUaPN
::# r44MB8dfhkfxbzwcexGDL3CzyltvmTHBkoa9UumcrtjpWWaUmGEyM8+MPXo18vS/waGX4Sj+xSXE
::# +7iy826VXsgxMwNL8NqquznJrKa9teKWT+ALr+U7jZSz0XArYGsLlzbnOo1Gdx52PYYV3IMKL8ww
::# c0I9UyH3StL5pQkwsZv8xEyD1sfVeCv/20maVoMo1J0V+Kwya55Zu8yymFlnRoGsX+Vrh3w2/dtJ
::# Bh/A58u4jlHka/v8TdYLmRdrtH89j7H2ok8GSL/EdWGwscyMJXslCcYIvyB2zNiExUWqMKb4c7XT
::# +tBdO0EDTFOmKmlevhRAaFy+dKWXqOseMrRbv+hDCYSF9gc/CP6Ib5zJ76D2PB4fjw0Gg88i8eeJ
::# J1eHxkbk1yDmLgCgo42uaD+90qOvIvrP+PMieNUhwm7R6DSPeG3Jae1AkCVwIIL/S8255bTzrglX
::# JYzEVWa2mfkVos7TKbe0CbcVusR9ETv4IjBBVyiLMgcSE7B3N/muc7yLoZT4qMpYW00FDgw6Qv44
::# ae8tdJNL7ifIa0niA3JpbWD1WIBF89EjVXJR/T+JSFR//BgRa+83wDtmFQgtCFGJYfhpHkv8gDnG
::# B3iYrGvx1DRP71CNLYCZ4hafTOMDybzCxkqfWxBPc86ZWAdXeH7eQxqGntdb7v46hJsfQwFUrzFj
::# C1a6f/fWDfgFjqJ5WAJFUVZYk9u7YgUIrj2/5xZntLGoZi9s8N1Ft33qlhfRoPSWPQ/P1bXQGcdD
::# 4HeZzwJOF7EUhBWAB2EIPuzFBe+cfT14/87tH3+EfOI66PGZEA5qwiZBHucso0j4wwlFwIzUIG4V
::# 6GM9PrnNs5DhKsYicPsm5Ebij1lvEGNWE2FLywbFHrC64sS8x1l8+gBM9MU8oLntL7CnoAMKUfSZ
::# FhjVvrui2TurrnXaaRbs0uLgd0R3sSAZMBCUu1P8mCngUpcAM0rCAsqbieB2Djf69gSQulOH16Cc
::# kNTMjIqH4W5N2YU9cRthkHzvbq7gGjOzit2LXePYzn7Ei/umwDZR3luMIhbcFrNWmXXAzD2Ka1uU
::# jCqTPG9PQiUjtUFQkIla9FlBa53MV4IYlHte+A1LQOG5jSrRQM3d2acWUCcynoHHmLGjIGrOuaUi
::# OmnkfESX4plpNF/uX0NmJsbuIxkAKUGOb83TiwLSmb54qQaAEfPjqq+EALx3n4djunZdNNb+rpSH
::# zACK7BlLEjJYaOZE8on7fGAE58RKNwY11b2geZQIlA3yULSf5Nmt/3Hx1l4TtZqd42ngBD4JnlZU
::# J0rLgBDngO8XFZyvXiXegJI8wjLnZJcSAUGlYAwMyPZ8AXmKYBoTAwNUcteuagMDsqnDJS10VXX4
::# uD4CvsT1WBBayEh4dDgWlLdU7UMOu2sp2EOVJVCcFAAyOf6M2e9NxBD1BmZVmLXArDSfalCN17TQ
::# v366d+fBvVu3/n33+oMfcP2qU2ryXEEUQKe53X0/7Sc/SsCf0HzpbC+aGezx3/RGvqa8cYsHDhgH
::# hbw8by+W8DuU2yFsPgFW4p4U29D12IuHMT36z4Qew5aM79aRw8wZEVh021vBeEfIroIygH7Pi9v8
::# 9C3JoIzAAZJGbYknt7CQwPg0hhPZiqpFxdWo3SBbI0Nh3DLGzCa1pS/MKmHVQwdsbneOqaJON/jJ
::# DC6y+JoaAYYKMq1pGtAeQYCnJnntqxbU7NfrsosZq54h3nVnNuW824egdk4LiLKJCvU4oTVzhFWx
::# aDFH8VkQFNJf4aBy0lhsRAdUPhUkD2zuS9TvajILfPmjs4vB4vkGT28T4UxjluF9I0V6zUv6nzHp
::# WGffTLFUJqE+Ydt7Y0QfGYuCloWQxiNxUlheXzM/EbOn3Z1Cp7WOUGgkyXVEo1zX2c2cx/zlS39B
::# +4gCvmmg0kY+C9Wl8ys/uHkzyKwUtb408Dn2Atnncl4v8x7whBgmrz0JSonPVqUuEtwVEt2NPpXf
::# Is28UUQllD2yJ3OI2/YitdIle/kQSvpi7r2QMX3yDwnjKA3qR9JcQPPd8RsLChkaaXd+o9M2iTaL
::# PL3AZ+p8tohr5KeoXUEHyjIz21Pj/l4Lkfq9+PCtfbuwIJ/uxWqOwF21l4+pgUmx5V8aXHn0KPxM
::# H40H4np4RMhHLRQfHg48S0SGdUkiRndtsdfE+OxEzzWqD29PSCVQQRXFA3F4dwm1jvt5D2cnVLZF
::# OTX5xJ/QlHZmn4z0agIlFW995Y2CkKT+wFoGJYN0rLWiBC1x29lkQi1vTXWX32B/Eo6bE8qGKsmk
::# nvsh4f3Q2LAeCEeHnkfi+lA8BOQhLkV1nCz0KF15koi8HA7o0ehYFG7Exl6+EjcgOG456VY+qqex
::# nhALn3F6M8sEoWMy/0AkCXxT/Qy6TxvFBfiRX6XmvaQI1NO+JfuwqRiuSEwyofJC/tF4UXXeN6DQ
::# BLO55V0Ya8T7qLCsHdJW8/jFqoAKQ+zB4PnmlM/C9Gc4h3tdq+zJJhh4ulNpQXIIAtNEi727ZRDB
::# e059gi9/AhL2z9Vel/ZPNucbAkyXsAJ62DczVWHlbv7T2bo80/HFxhi5xdc4V2AlprtT06gMIeMb
::# llPIO1+WZHn28bg3Rxl5Z8VwCttKbYBsqg8MiCkRa5VcPSv71FQ/MKBczpJIEV1QPC3v1b0eqjpa
::# /XcMgSHRVE1EcgHVRQqcUjZKx8EjOV44wAKbWRji7beoJaQom6l3kylxBV5+OhYd0rXxROw59goY
::# nTXArB7XAoHn4ehwCCc+iQcApcEz2e77LUzN/ra9e0j8Ab0O0pcGNFMsAW2T+/ZKBvs1Vn6KWWtI
::# W6f73dW2CKRnDkhhwJM4CuGTv3bncyDtHOJRadHde8HbsVhCl7LSBH4BO9ZliYAdYgWsoRNkGBQh
::# uJqdLTjlNlm/TizQFOXVBYC213u2+p3DQUCpV56espfbYMc5eRr0riTGh6G9Kb1KoK86wMO7G5BQ
::# dUJxRgECpNB1M/fzWPRFPKrrcoDxnWJJROK4A8WC7KgGGqSlijhX6TXAnrhQPaLvKM0rMVks/YKl
::# LoaqvhMqo97dhITu4TmSgqcssW8eNmEIWzlICp8qgqLC1zyt5mkbqKDe6ZJPE9LeSitWgVxojiVl
::# JDW8twmEzDuL8DdTv2ln+oasCUU9UCw5O2+QxsHFwX9gftuaBJbpIdPcYCaoiKLEW49rMSXdtbSY
::# 3LI02ebP1CE0KsVBVXfnE0phP/pVVmkJIhIiSek3FCoM5rCQs7rsLLdUY8+S1zs97jXngKWZ+VYw
::# hDx6EPxklN31D07FELsqSIELMoj4AoS6A3ZBVwHQInfJfEt7e728LMONua4KySLWBY52jpZ8T1Ju
::# IBP4kzIBuKc23WnOE5Xj+AYkJNzzywVYpzfZwfDuy6UQ8QQPfyco+Y811QFCf1fwvwDlLNKGZ7QL
::# 2/bKr9CNZbmpsbKmTjWrQkVK+ILiEHKy//gUV4Shfmdf9lZZR3XVpP18DLOnOABQBzxouDjMSKMy
::# 8gagcwfVJGzwDIgmQP/RrDyMomYupw7VlhRSa3iyUCyBpXJyF8dY3xhcMNtZqtgDn3io9QuGDA0n
::# IsJyVFLpFJviMj4cBC9kjj6UUUWLWYwmi55mtZo9Balg5HyetT+uXL70V7BiKwMKj8T4OsW06ned
::# GlssHo4nYkDg+GM48vQpNDm8FoKhDqTNBDn0t6seRdRotR118rChwOzRccXnD9h1QodUUuJIWAEC
::# v09AI42GIy9j6tCv13JEvwmKboPdHyCoJmsSZD0qd2rrEJee1kYUabdvqgm4LuCqhQhdjx4+vH3z
::# 7/a68RjaE0xWR7vEdT7tSxP+VywbVQj4bweSbEh//f8iILFMrOKJHaW26j2+owMDT3MEPa0RBNgD
::# n0q6l+zn9Zz6OdqE7f4PUEsHCMQCv+U3DAAAOxoAAFBLAwQUAAAAAAA1dkZdAAAAAAAAAAAAAAAA
::# EAAgAHNwZWNraXQtcmVxdWlyZS91eAsAAQQAAAAABAAAAABVVA0AB/aLxGrVjMRq9ovEalBLAwQU
::# AAgACAA1dkZdAAAAAAAAAAAAAAAAGAAgAHNwZWNraXQtcmVxdWlyZS9TS0lMTC5tZHV4CwABBAAA
::# AAAEAAAAAFVUDQAH9ovEamuMxGr2i8RqjVZLUxs5EL5TxX+YCpfFVWYq+7hw21qym1QOSZFU7XFx
::# zCS4iA07MyS7N2uGh7ENBhLbENiYhwFjYhMCRbwY8H9ZWZrhlL+QljQaP0jVcrEljdTq7u/rTx0M
::# Bnt7YqGoNqgYk1p4PGIGde3PqYiu9faMakZYj0yakYnYoPJbxLw/9Ux5ApuUhxFT+W7MNCeNQVV9
::# ETHHpp4NhCei3lBlhoJgqV/B1krzsoHRDkZ77h5q1s9I9Z1zdYCt6WY9S/dXm5cbNLH05SIhpk4l
::# BxuwXRdTul4TG/wVt1RxSwkwS5YOsRX/cjEPY5r76O5lvJ3oCqMCRkc0v00qq+IURjW3cemWYJDH
::# ccT8G4iOqpMvQzH2b4aMcQMG/Oy+87YgbqTrp2AZozVspXDc6vA/jsQUzJLkpkqK87AbVp8ODZH5
::# BZoBP6piB82eOkuz8Em6UqWrizQ3R9I5WJTphGXmVeT532r4ZUhn/8w74Rq2s9iuYPuCVAvuVhqj
::# ND22sIWwBdGnmXeohNECRoeQbOdtCZzt7QkyYHt7+pRhAWdUi5mGDx/71IXooPL/iHKLfcqjV5r+
::# KqK9/oYVBSLBdhnb/2Crhu0EjMnsDLZnsX2C7Ty2P0AcbB1ctv7F1hHfnGcrHlem/eRKrqz4JJCQ
::# 5IFPigej8t/siuJByccSTsY+Uk1zUmQxWhcwdpIlJWgi2ZFiRxJFmqsIppCjK/d4S3ny+N4vzJqz
::# fc7oya/nm+eZnd2KzxEvP/SY75OwDSrtlyoTutJ+KzsTVLC9xxJjnTGYZ3ZJch2oSBZOwJSwPsi9
::# CD4YahEYDi2zJMaRz3ocTwurqrgCxxdoes4pghHgjcXogj7KaH2ng4rb+IzRLNk8JUsJv3j8uGlx
::# wzndln6M6C+UYEy5A3EeFFz7UhB78A4HxFC5mwHV83EECFFq1uqAKLYqHPsj/jsP8TVrcXfuFLLq
::# lhc63BEfwOe7QAOMypDpLqfd4hzNfpT72AYSX3N3NkBKZJ4YwxrYKnIWHnpSkVniyWAIXqMaTb5n
::# i1413bjdmd7CaFkkrZM3HaljjtE1C/LWwRdUVV5P6OOmrmnqcy1kTukaIJbD9gGvBcQS0EYf8Hxk
::# QIqAEF5DfRYyxtTwGAhzcFLXuDIbEVMzBowxltkjuhEHx3ygICSMzhgVLMQC9hnpZZ2Vm0dKuM67
::# jBeNpzp+MbUqCewII33K3X7FOyNI2/LX1KJwChxTQTWiodiooXqfBAesFbcMcTZYbZdWXXANZOJG
::# /d8l6++lxrVl+FvXcEWSU3kH0z7QjzZtYOjmd+nGB7f8nhVUIdWBdDuoAsEup8jcOS/FqjLy+6Ph
::# h0+H79374/HPT++z5B86+3WSygoyNeu712tA4qoHKQTMopiVF7UVvLjIPfhELt9gq86usz5je5+x
::# ArKCGi2VY0qYAh9gfL0JElr/ddjJlknmM6M8OoDt1/EdWGGxn1VoGnXkDR4jlSkvhGQnoAAZzz0Z
::# SPml7qtt6+VMLJFkgRTO6XkOomSSMldmgUpTYIQ0Zq43E6AukFRhkOZLLNmri93SMiJkgf9KoNoj
::# DATIdJnMJMj5XiAARRsIOMkzOpOCCYhxYwajd5IyskymJkcB9SDnQCQ2qv0lysF7QKSMWRZZSoMy
::# tRdCn/J9v+T6LTjs7fR07JBcvWlB6p6USTYjapAU93/CqAhbaHIZI0gMooslslsCQjuVt23C05YY
::# 7xs6arEVmoZv06LGnoI1i2QW6Opm13PTp/zQz2v2FgF57+TNaFqnolp0Qoc2ZCJmmBFzinV/EjaS
::# sZyZfQEbtj6Jl9w9yDavtliI53FOoDUZH68dwEs+zqqia4YW0sNjYgYghoLRiVHtpZiDuIXHDTOk
::# m2IOLph6KAwyKMTb68y6o/+xXwjVLcKXrcHN+G9XK34FsIeFC4WkKO9H25Sl1YSwfgg+AI62pyzc
::# BLncJhcZyM6DIfWJyTLOpNna4g/WoXjZRdhk8YRUE909hq9MZPOYLCdF8CJDalubVJDkAsg8HGDU
::# 6R1vIuAebqiDonSj7O7v8B6Eta2s/4G2FfrPaqpLQzr6F0l6ctXqlOgHeEtr1/FP0LZz618BUEsH
::# CArLEBshBgAAegwAAFBLAwQUAAAAAAA1dkZdAAAAAAAAAAAAAAAADwAgAHNwZWNraXQtdXBkYXRl
::# L3V4CwABBAAAAAAEAAAAAFVUDQAH9ovEatWMxGr2i8RqUEsDBBQACAAIADV2Rl0AAAAAAAAAAAAA
::# AAAXACAAc3BlY2tpdC11cGRhdGUvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVA0AB/aLxGprjMRq
::# 9ovEaoVWXU8bRxR9R+I/jMJLoVk2/VTLWxRQGrVVq0YoD0kkG3sJbmxs2SYob55d4qw/qClJMCQm
::# wYgPx8QmTghNAsb/pcPs2k/5C713dr1er1tVAms9vnPnnnPPubOSJA0PzfsjygRJxJTA3VBSWogF
::# /UlleCioJALxUCwZis5PkKuh5A8LM+Q6xJAfQ0ny2VwyGUtMyPKdUHJuYWY8EI3YjzLmkSDRKGG0
::# zrQNpp0y9QPTVsTDe6btM+2t8ezIWHvN1CWmpeEr04pMe4UBmi5jtHrItKpY1flK3ii9YOpqu5xn
::# NM0oPFNIbWRyna00S6ndonDNSpui5++zxjsqclTtAmgFAvhfda6nO/Sl+bgCYUklEgsD2oQMACL+
::# +WBCtkAnMLawxtRs++yU0RbEMq0mMh0w7aBDc5Dg06luFHeN0qt29TnPrzHthGnw+VIAop3N58aj
::# 5fNmCdav/zp1Rbo5PX1t8jujTG9/Os1AfvO4ZuQBSZ63HrT34KEqalxm9OC82cIC6QZTc4BweEjC
::# Pg0PjfQ6MG23aXjI05sJ8v+9EblGyC/3lPi9kLLYy8IfvOKnBdKNwxYioW4e1VWjuM1r62JlU3RU
::# x2daJ75x3BiavS/7YOcBLywb61uMFoE9ew+tW9QBh6LbB14Oked/4zBFkUNybZI3t6FCZFBdPW9t
::# CgaLKAp6Bn+2AHrECZw3ovG7s+HoovV1hHwxSszCmZk9NrJZo1DGZYl48PD0A4TUY+I/lAxlmJkP
::# vP7UOhTwnJ/lJogvfodI8+TCvUu3bo3j/81L0ve3P7/gw8pFR3upzccNY3MXFXd41m6UISPXi0Z+
::# w5OxR+5F+BII+xeCiku3ln3Hx8YjQecQC+6Xo6Trh77Sze2P7eqyhd5qfx9io5QSHm0x9bXskYC1
::# 1SnwhjJj7JTMo23RBejFobXt/H2qvbffg2y1pwsTI1BOjY/o6BRtv3zDm4+cdeID1ZJAODqvoJz2
::# wY/8rOjp7Qj5apRYrrZ+t+DYeEWqztojEgzNzkKOnDMa/k6vug1tBwDz3kMkwncyULfTm87DZVP9
::# 4CZgYniIEIn4etPEN7Di9Kn7kz1nZOiVPuNPzMmx6KIST8wp4TDwZQdFlEg0fh/3SKTdavLslswz
::# 2c7GDtOeMBWq2UEjqSpMEEafWmoeIOhrmMR9swuHXx9NoDyBEdC5I10WdtExNgandbZ0Md17wVw/
::# No+WkMH0snXE2JhNDG6nMID3HKfb6y6n2zaHqbhHjdo2kOK5BuBagLjnIhqm5wEJzIHgowtJObEY
::# Sgbm5EBcAabhsLxRzzE1I+bpksOlPT7g90Pi88xjwa9nQlmagmyMqgCebx3xFR2FnaLmixpkNlfS
::# YFy8lyrrnfybAdq/QdphSgFFu0wri8J1ywDdgdPnxna5ApnQD64Z5pj/yk+Xpyen0NsXXZPgt6nL
::# kz9PuR3veKyxa9SOBssHFeEp3mK/HSVg4HYF7roK32rwP7NdgZzg1dTfCtRL7gm2C8CfNBkteMaB
::# T5JAxzEsVZJ+T0TnfcSsZXolwnAUjm7nGiAGvGPqOeReXTKK+/9OCwLBfoKH3Yf1WdTEMt8JkVSh
::# TbzZ6LxomYdL/NkbvIFKVfAwb5Wc1wDkev0PSIdCF6C9F8fVBX88GPeHwoluy3qKBfyGviJz/aHx
::# rIXMwuuJWuiqDq6QPQHjGD7NehnU0sPf1aJ1l8Fey7+DusSJ1H1NcMF1bGsTOPAOBSkdrwE4s3XS
::# rrwV9+QeDkE1M+DrfwBQSwcI5GAWyikFAAAJCgAAUEsBAhQDFAAAAAAANXZGXQAAAAAAAAAAAAAA
::# AAcAGAAAAAAAAAAAAP9BAAAAAGNvbW1pdC91eAsAAQQAAAAABAAAAABVVAUAAfeLxGpQSwECFAMU
::# AAgACAA1dkZdRenERhECAACMAwAADwAYAAAAAAAAAAAAtoFFAAAAY29tbWl0L1NLSUxMLm1kdXgL
::# AAEEAAAAAAQAAAAAVVQFAAH3i8RqUEsBAhQDFAAAAAAANXZGXQAAAAAAAAAAAAAAAAcAGAAAAAAA
::# AAAAAP9BswIAAGNvbXB1cy91eAsAAQQAAAAABAAAAABVVAUAAfeLxGpQSwECFAMUAAgACAA1dkZd
::# Kni58TcCAADHAwAADwAYAAAAAAAAAAAAtoH4AgAAY29tcHVzL1NLSUxMLm1kdXgLAAEEAAAAAAQA
::# AAAAVVQFAAH3i8RqUEsBAhQDFAAAAAAANXZGXQAAAAAAAAAAAAAAAAgAGAAAAAAAAAAAAP9BjAUA
::# AGZlYXR1cmUvdXgLAAEEAAAAAAQAAAAAVVQFAAH2i8RqUEsBAhQDFAAIAAgANXZGXcP0F1LMBgAA
::# YAwAABAAGAAAAAAAAAAAALaB0gUAAGZlYXR1cmUvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVAUA
::# AfaLxGpQSwECFAMUAAAAAAA1dkZdAAAAAAAAAAAAAAAACAAYAAAAAAAAAAAA/0H8DAAAaGFuZG9m
::# Zi91eAsAAQQAAAAABAAAAABVVAUAAfeLxGpQSwECFAMUAAgACAA1dkZdanSY5y4FAAAJCQAAEAAY
::# AAAAAAAAAAAAtoFCDQAAaGFuZG9mZi9TS0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUBQAB94vEalBL
::# AQIUAxQAAAAAADV2Rl0AAAAAAAAAAAAAAAAPABgAAAAAAAAAAAD/Qc4SAABoYW5kb2ZmLXNvbm5l
::# dC91eAsAAQQAAAAABAAAAABVVAUAAfaLxGpQSwECFAMUAAgACAA1dkZdaldqqmcBAACjAgAAGQAY
::# AAAAAAAAAAAA/4EbEwAAaGFuZG9mZi1zb25uZXQvbGF1bmNoLmNtZHV4CwABBAAAAAAEAAAAAFVU
::# BQAB9ovEalBLAQIUAxQACAAIADV2Rl0bXORSYQcAAOUNAAAXABgAAAAAAAAAAAC2gekUAABoYW5k
::# b2ZmLXNvbm5ldC9TS0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUBQAB9ovEalBLAQIUAxQAAAAAADV2
::# Rl0AAAAAAAAAAAAAAAAMABgAAAAAAAAAAAD/Qa8cAABpLWhhdmUtYWRoZC91eAsAAQQAAAAABAAA
::# AABVVAUAAfeLxGpQSwECFAMUAAAAAAA1dkZdAAAAAAAAAAAAAAAAEwAYAAAAAAAAAAAA/0H5HAAA
::# aS1oYXZlLWFkaGQvYWdlbnRzL3V4CwABBAAAAAAEAAAAAFVUBQAB94vEalBLAQIUAxQACAAIADV2
::# Rl2IS260gQIAAEIEAAATABgAAAAAAAAAAAC2gUodAABpLWhhdmUtYWRoZC9MSUNFTlNFdXgLAAEE
::# AAAAAAQAAAAAVVQFAAH3i8RqUEsBAhQDFAAIAAgANXZGXSpbOCVgDQAAtRwAABQAGAAAAAAAAAAA
::# ALaBLCAAAGktaGF2ZS1hZGhkL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQFAAH3i8RqUEsBAhQD
::# FAAIAAgANXZGXbd0t4zWAAAASgEAABcAGAAAAAAAAAAAALaB7i0AAGktaGF2ZS1hZGhkL1VQU1RS
::# RUFNLm1kdXgLAAEEAAAAAAQAAAAAVVQFAAH3i8RqUEsBAhQDFAAIAAgANXZGXTuVriuVBAAAhQgA
::# AB4AGAAAAAAAAAAAALaBKS8AAGktaGF2ZS1hZGhkL2FnZW50cy9nZW1pbmkudG9tbHV4CwABBAAA
::# AAAEAAAAAFVUBQAB94vEalBLAQIUAxQACAAIADV2Rl0V0kJjrwAAAPUAAAAeABgAAAAAAAAAAAC2
::# gSo0AABpLWhhdmUtYWRoZC9hZ2VudHMvb3BlbmFpLnlhbWx1eAsAAQQAAAAABAAAAABVVAUAAfeL
::# xGpQSwECFAMUAAAAAAA1dkZdAAAAAAAAAAAAAAAACgAYAAAAAAAAAAAA/0FFNQAAb3Zlcm5pZ2h0
::# L3V4CwABBAAAAAAEAAAAAFVUBQAB9ovEalBLAQIUAxQACAAIADV2Rl0awnXNBgkAAPsQAAASABgA
::# AAAAAAAAAAC2gY01AABvdmVybmlnaHQvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVAUAAfaLxGpQ
::# SwECFAMUAAAAAAA1dkZdAAAAAAAAAAAAAAAADwAYAAAAAAAAAAAA/0HzPgAAb3Zlcm5pZ2h0LWdv
::# YWwvdXgLAAEEAAAAAAQAAAAAVVQFAAH3i8RqUEsBAhQDFAAIAAgANXZGXfUO7A0kCAAADxAAABcA
::# GAAAAAAAAAAAALaBQD8AAG92ZXJuaWdodC1nb2FsL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQF
::# AAH3i8RqUEsBAhQDFAAAAAAANXZGXQAAAAAAAAAAAAAAAAcAGAAAAAAAAAAAAP9ByUcAAHBpY2t1
::# cC91eAsAAQQAAAAABAAAAABVVAUAAfaLxGpQSwECFAMUAAgACAA1dkZdtg3kiQIGAAC6CgAADwAY
::# AAAAAAAAAAAAtoEOSAAAcGlja3VwL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQFAAH2i8RqUEsB
::# AhQDFAAAAAAANXZGXQAAAAAAAAAAAAAAAAsAGAAAAAAAAAAAAP9BbU4AAHByaW9yaXRpZXMvdXgL
::# AAEEAAAAAAQAAAAAVVQFAAH2i8RqUEsBAhQDFAAIAAgANXZGXQC9ga13BgAAMQwAABMAGAAAAAAA
::# AAAAALaBtk4AAHByaW9yaXRpZXMvU0tJTEwubWR1eAsAAQQAAAAABAAAAABVVAUAAfaLxGpQSwEC
::# FAMUAAAAAAA1dkZdAAAAAAAAAAAAAAAABQAYAAAAAAAAAAAA/0GOVQAAcHVsbC91eAsAAQQAAAAA
::# BAAAAABVVAUAAfeLxGpQSwECFAMUAAgACAA1dkZdzkfnTggCAADJAwAADQAYAAAAAAAAAAAAtoHR
::# VQAAcHVsbC9TS0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUBQAB94vEalBLAQIUAxQAAAAAADV2Rl0A
::# AAAAAAAAAAAAAAAFABgAAAAAAAAAAAD/QTRYAABwdXNoL3V4CwABBAAAAAAEAAAAAFVUBQAB94vE
::# alBLAQIUAxQACAAIADV2Rl2KKOM2OgEAACkCAAANABgAAAAAAAAAAAC2gXdYAABwdXNoL1NLSUxM
::# Lm1kdXgLAAEEAAAAAAQAAAAAVVQFAAH3i8RqUEsBAhQDFAAAAAAANXZGXQAAAAAAAAAAAAAAABMA
::# GAAAAAAAAAAAAP9BDFoAAHNwZWNraXQtYXV0b25vbW91cy91eAsAAQQAAAAABAAAAABVVAUAAfaL
::# xGpQSwECFAMUAAgACAA1dkZdxAK/5TcMAAA7GgAAGwAYAAAAAAAAAAAAtoFdWgAAc3BlY2tpdC1h
::# dXRvbm9tb3VzL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQFAAH2i8RqUEsBAhQDFAAAAAAANXZG
::# XQAAAAAAAAAAAAAAABAAGAAAAAAAAAAAAP9B/WYAAHNwZWNraXQtcmVxdWlyZS91eAsAAQQAAAAA
::# BAAAAABVVAUAAfaLxGpQSwECFAMUAAgACAA1dkZdCssQGyEGAAB6DAAAGAAYAAAAAAAAAAAAtoFL
::# ZwAAc3BlY2tpdC1yZXF1aXJlL1NLSUxMLm1kdXgLAAEEAAAAAAQAAAAAVVQFAAH2i8RqUEsBAhQD
::# FAAAAAAANXZGXQAAAAAAAAAAAAAAAA8AGAAAAAAAAAAAAP9B0m0AAHNwZWNraXQtdXBkYXRlL3V4
::# CwABBAAAAAAEAAAAAFVUBQAB9ovEalBLAQIUAxQACAAIADV2Rl3kYBbKKQUAAAkKAAAXABgAAAAA
::# AAAAAAC2gR9uAABzcGVja2l0LXVwZGF0ZS9TS0lMTC5tZHV4CwABBAAAAAAEAAAAAFVUBQAB9ovE
::# alBLBQYAAAAAJAAkACIMAACtcwAAAAA=
