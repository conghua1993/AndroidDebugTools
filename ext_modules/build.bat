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
    if exist build.bat (
        echo [RUN] %%D\build.bat
        call build.bat
        if errorlevel 1 (
            echo [WARN] build.bat failed in %%D
        ) else (
            [OK] build.bat finished in %%D
        )
    ) else (
        echo [SKIP] build.bat not found in %%D
    )

    popd
)

echo.
echo ==========================================
echo All builds finished
echo ==========================================