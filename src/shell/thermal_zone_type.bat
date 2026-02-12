@echo off
setlocal enabledelayedexpansion

for /l %%i in (0,1,200) do (
    set "type="

    for /f "delims=" %%a in (
        'adb shell cat /sys/class/thermal/thermal_zone%%i/type 2^>nul'
    ) do set "type=%%a"

    if "!type!" == "" (
        goto: END
    )
)

:END