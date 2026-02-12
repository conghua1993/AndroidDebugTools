@echo off
setlocal enabledelayedexpansion

@REM echo =================================
@REM echo Python scripts -> EXE(Auto Cleaner)
@REM echo =================================

REM chdir to current dir
cd /d %~dp0

set TARGET_BIN=..\..\src\bin

del /q *.spec
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist

echo.

echo =========================
echo Clean finish
echo =========================
