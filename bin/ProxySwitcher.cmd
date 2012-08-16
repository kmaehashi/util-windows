@echo off & setlocal & setlocal ENABLEDELAYEDEXPANSION

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Windows プロキシ切り替え
:: @author Kenichi Maehashi <webmaster@kenichimaehashi.com>
:: @version 2011-09-15
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set retval=0
call :_init %*
call :_main
goto :_return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:_init
:: 初期化を実行します。
:: @param %* 無視されます。

:: レジストリのキー名を指定します。
set REG_KEY=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:_main
:: メイン処理を実行します。
:: @return 処理が成功した場合は 0

call :print_header

set retval=1
set proxy_enabled=error
set state_new_value=

for /f "usebackq tokens=3" %%v in (`reg query "%REG_KEY%" /v "ProxyEnable" 2^> nul`) do (
	set proxy_enabled=%%v
)

if "%proxy_enabled%" == "0x1" (
	set state_current=有効
	set state_new=無効
	set state_new_value=0x0
) else if "%proxy_enabled%" == "0x0" (
	set state_current=無効
	set state_new=有効
	set state_new_value=0x1
) else (
	call :print_header
	echo 　プロキシの状態を取得できませんでした。
	call :wait
	goto _return
)

call :confirm "プロキシを [%state_current%] から [%state_new%] に変更します。" && (
	call :set_proxy %state_new_value% && (
		call :print_header
		echo 　プロキシを [%state_new%] にしました。
		set retval=0
	) || (
		call :print_header
		echo 　プロキシを [%state_new%] にできませんでした。
	)
)

call :wait

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:wait
:: 確認メッセージを表示します。

echo.
echo 　何かキーを押すと終了します。
pause > nul

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:confirm
:: 確認メッセージを表示します。
:: @param %1 クオートされた文字列
:: @return 続行する場合は 0

echo 　%~1
echo.
echo 　続行する場合は、何かキーを押してください。
echo 　中断する場合は、ウィンドウの [X] ボタンをクリックして閉じてください。
pause > nul

set retval=0
goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:set_proxy
:: プロキシの設定を変更します。
:: @param %1 設定する ProxyEnable の値
:: @return 成功した場合は 0

set retval=1

reg add "%REG_KEY%" /v "ProxyEnable" /t REG_DWORD /d %1 /f 2> nul && (
	set retval=0
)

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:print_header
:: 画面をクリアしてヘッダを表示します。

cls
echo ============================================================
echo                   Windows プロキシ切り替え                  
echo ============================================================
echo.

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:_return
:: リターンします。

exit /b %retval%

