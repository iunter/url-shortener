
@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0load-env.ps1" %*
exit /b %ERRORLEVEL%
