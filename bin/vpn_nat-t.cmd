@echo off

:: Enable NAT-Traversal on both side for L2TP/IPsec VPN
:: http://support.microsoft.com/kb/947234/en-us

reg add HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule /d 2 /t REG_DWORD

echo Reboot required to make changes affected.
pause

