@echo off

:: Tune Windows 7 Parameters for faster access over SMB

netsh interface tcp show global
netsh interface tcp set global rss=disabled chimney=disabled netdma=disabled
