@echo off
setlocal enabledelayedexpansion


cd /d %~dp0

set ROOT_DIR=%cd%

for /d %%D in (*) do (
    echo.
    echo ----------------------------------------------
    echo Enter directory: %%D
    echo ----------------------------------------------

    pushd "%%D"
    if exist clean.bat (
        echo [RUN] %%D\clean.bat
        call clean.bat
        if errorlevel 1 (
            echo [WARN] clean.bat failed in %%D
        ) else (
            [OK] clean.bat finished in %%D
        )
    ) else (
        echo [SKIP] clean.bat not found in %%D
    )

    popd
)

echo.
echo ==========================================
echo All clean finished
echo ==========================================