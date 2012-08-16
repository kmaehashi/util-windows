@echo off & setlocal
:START
set INPUT=
set /p INPUT=
if "%INPUT%" equ "" goto START
if "%INPUT%" equ "quit" goto :EOF
set /a ANSWER=%INPUT%
echo.%ANSWER% & goto START