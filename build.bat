@echo off
chcp 65501 > nul
setlocal

set PYTHON_EXE=python
set SRC_DIR=src
set ENTRY_PY=%SRC_DIR%\main.py
set APP_NAME=AndroidDebugTools
set DIST_DIR=dist
set BUILD_DIR=build
set OUTPUT_DIR=Output


cd /d %~dp0

echo clean build/dist ...
rmdir /s /q %BUILD_DIR% 2>nul
rmdir /s /q %DIST_DIR% 2>nul
rmdir /s /q %OUTPUT_DIR% 2>nul
del /f /q %APP_NAME.spec% 2>nul

:: install PyInstaller
%PYTHON_EXE% -m PyInstaller --version >nul 2>&1
if errorlevel 1 (
    echo installing PyInstaller...
    %PYTHON_EXE% -m pip install PyInstaller
    if errorlevel 1 (
        echo install PyInstaller fail
        pause
        exit /b 1
    )
)

:: check entry point
if not exist %ENTRY_PY% (
    echo cannot find entryfile: %ENTRY_PY%
    pause
    exit /b 1
)

:: building
echo.
echo building

%PYTHON_EXE% -m PyInstaller ^
    --onefile ^
    --clean ^
    --noconsole ^
    --name %APP_NAME% ^
    --paths %SRC_DIR% ^
    "%ENTRY_PY%"

if errorlevel 1 (
    echo,
    echo PyInstaller build fail!
    pause
    exit /b 1
)

echo.
echo PyInstall Build Successful
echo.
