@echo off
setlocal
title Laravel System Runner
cd /d "%~dp0"

REM Prefer PowerShell 7 if available, else fall back to Windows PowerShell
where pwsh >nul 2>&1 && (
  pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -NoExit -File ".\setup-laravel.ps1"
) || (
  powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -NoExit -File ".\setup-laravel.ps1"
)

endlocal
