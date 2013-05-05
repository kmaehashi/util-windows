@echo off

reg add HKCU\Software\Classes\AllFilesystemObjects\shell\CopyPathForMailer /ve /t REG_SZ /d "パスのコピー(メール用)" /f
reg add HKCU\Software\Classes\AllFilesystemObjects\shell\CopyPathForMailer\command /ve /t REG_SZ /d "\"%~dp0\CopyPathForMailer.cmd\" %%1 | clip" /f

pause