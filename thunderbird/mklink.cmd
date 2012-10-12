@echo off

for /F "usebackq delims=" %%f IN (`dir /b %APPDATA%\Thunderbird\Profiles\ ^| findstr ".*\.default"`) do (
  set PROFILE_NAME=%%f
)

if "%PROFILE_NAME%"=="" (
  echo "Profile not found"
  exit 1
)

echo Profile: %PROFILE_NAME%
mklink /j %APPDATA%\Thunderbird\Profiles\%PROFILE_NAME%\chrome chrome

echo.
pause
