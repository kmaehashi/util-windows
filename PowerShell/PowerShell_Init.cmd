@echo off

set WPS_DIR=%USERPROFILE%\Documents\WindowsPowerShell

mkdir %WPS_DIR%
copy Profile.ps1 %WPS_DIR%

echo Now run the following command in PowerShell with admin privilege
echo Set-ExecutionPolicy RemoteSigned

pause

