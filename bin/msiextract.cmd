@echo off & setlocal

:: MSIEXTRACT v0.1
:: 	Copyright (C) 2009 Kenichi Maehashi, All Rights Reserved.

call :_INIT %*
call :_MAIN
goto :RETURN

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:_INIT
:: Initialize the variables.
:: @params %* program arguments.

	set MSIEXTRACT=%~n0

	set AUTO_OPEN=TRUE
	if "%~1" == "-N" (
		set AUTO_OPEN=FALSE
		shift
	)

	set MSI=%~f1
	set DIR=%~f2

	goto :RETURN

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:_MAIN
:: Main process.

	if "%MSI%" == "" (
		call :SHOW_USAGE
		goto :RETURN
	)
	if not exist "%MSI%" (
		echo %MSI%: No such file or directory
		goto :RETURN
	)

	if "%DIR%" == "" (
		call :SHOW_USAGE
		goto :RETURN
	)
	if not exist "%DIR%" (
		echo %DIR%: No such file or directory
		goto :RETURN
	)

	echo MSIEXTRACT Started on %DATE% %TIME%
	echo.

	echo Target MSI: %MSI%
	echo Extract To: %DIR%
	echo.

	echo Extracting...
	start /wait "" "%WINDIR%\system32\msiexec.exe" /a "%MSI%" targetdir="%DIR%" /qn
	set MSIEXEC_ERR=%ERRORLEVEL%
	if %MSIEXEC_ERR% == 0 (
		echo Done!
	) else (
		echo Error: MSIEXEC exit with status %MSIEXEC_ERR%.
	)

	echo.

	if "%AUTO_OPEN%" == "TRUE" (
		start "" "%DIR%"
	)

	echo MSIEXTRACT Completed on %DATE% %TIME%

	goto :RETURN

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:SHOW_USAGE
:: Show usage of this script.

	echo Usage: %MSIEXTRACT% [-N] MSI_FILE EXTRACT_TO_DIR
	echo 	-N: Do not open the destination directory after extraction

	goto :RETURN

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:RETURN
:: Return to the callee.

	goto :EOF
