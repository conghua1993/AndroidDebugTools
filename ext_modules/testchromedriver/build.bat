@echo off
setlocal enabledelayedexpansion

@REM echo =================================
@REM echo Python scripts -> EXE(Auto Builder)
@REM echo =================================

REM chdir to current dir
cd /d %~dp0

set TARGET_BIN=..\..\src\bin

where pyinstaller >nul 2>&1
if errorlevel 1 (
    echo [Error] PyInstaller not found, pls run : pip install PyInstaller
    pause
    exit /b 1
)

if exist build rmdir /s /q build
if exist dist rmdir /s /q dist

for %%f in (*.py) do (
    if not "%%f" =="__init__.py" (
        echo.
        echo [BUILD] %%f
        pyinstaller ^
            --onefile ^
            --clean ^
            --console ^
            --name "%%~nf" ^
            "%%f"

        if errorlevel 1 (
            echo [FAILED] %%f
        ) else (
            echo [SUCCESS] %%~nf.exe
        )
    )
)

if not exist %TARGET_BIN% (
    echo create: %TARGET_BIN%
    mkdir %TARGET_BIN%
)

echo.
echo cp exe to %TARGET_BIN%
for %%e in (dist\*.exe) do (
    echo copy %%~nxe
    copy /y "%%e" "%TARGET_BIN%" >nul
)


echo.

echo =========================
echo Build finish
echo =========================
