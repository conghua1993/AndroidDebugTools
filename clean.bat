@echo off
setlocal enabledelayedexpansion


cd /d %~dp0

set ROOT_DIR=%cd%

rmdir /s /q dist 2>nul
rmdir /s /q build 2>nul
rmdir /s /q Output 2>nul

del /q *.spec

echo.
echo ==========================================
echo All clean finished
echo ==========================================