@echo off

call :get "%*"
call :display %DIRECTORY% %FILENAME%
goto :eof

:get
set DIRECTORY="%~dp1"
set FILENAME="%~nx1"
for /f "usebackq tokens=1*" %%i in (`net use %~d1 2^>nul ^| findstr "\\"`) do (
  set DIRECTORY="%%j%~p1"
)
goto :eof

:display
:: for Outlook users
::echo ^<%~1^>
echo %~1
echo %~2
goto :eof