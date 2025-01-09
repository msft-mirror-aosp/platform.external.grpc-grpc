@echo off

set retries=3
set cmd=%*

:retry
%cmd%
if %errorlevel% == 0 (
    echo Command succeeded.
    exit /b 0
)

set /a retries-=1
if %retries% == 0 (
    echo Command failed after multiple retries.
    exit /b 1
)

echo Command failed, retrying (%retries% retries remaining)...
timeout /t 2 /nobreak > nul
goto retry