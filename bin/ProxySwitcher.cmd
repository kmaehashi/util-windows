@echo off & setlocal & setlocal ENABLEDELAYEDEXPANSION

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Windows �v���L�V�؂�ւ�
:: @author Kenichi Maehashi <webmaster@kenichimaehashi.com>
:: @version 2011-09-15
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set retval=0
call :_init %*
call :_main
goto :_return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:_init
:: �����������s���܂��B
:: @param %* ��������܂��B

:: ���W�X�g���̃L�[�����w�肵�܂��B
set REG_KEY=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:_main
:: ���C�����������s���܂��B
:: @return ���������������ꍇ�� 0

call :print_header

set retval=1
set proxy_enabled=error
set state_new_value=

for /f "usebackq tokens=3" %%v in (`reg query "%REG_KEY%" /v "ProxyEnable" 2^> nul`) do (
	set proxy_enabled=%%v
)

if "%proxy_enabled%" == "0x1" (
	set state_current=�L��
	set state_new=����
	set state_new_value=0x0
) else if "%proxy_enabled%" == "0x0" (
	set state_current=����
	set state_new=�L��
	set state_new_value=0x1
) else (
	call :print_header
	echo �@�v���L�V�̏�Ԃ��擾�ł��܂���ł����B
	call :wait
	goto _return
)

call :confirm "�v���L�V�� [%state_current%] ���� [%state_new%] �ɕύX���܂��B" && (
	call :set_proxy %state_new_value% && (
		call :print_header
		echo �@�v���L�V�� [%state_new%] �ɂ��܂����B
		set retval=0
	) || (
		call :print_header
		echo �@�v���L�V�� [%state_new%] �ɂł��܂���ł����B
	)
)

call :wait

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:wait
:: �m�F���b�Z�[�W��\�����܂��B

echo.
echo �@�����L�[�������ƏI�����܂��B
pause > nul

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:confirm
:: �m�F���b�Z�[�W��\�����܂��B
:: @param %1 �N�I�[�g���ꂽ������
:: @return ���s����ꍇ�� 0

echo �@%~1
echo.
echo �@���s����ꍇ�́A�����L�[�������Ă��������B
echo �@���f����ꍇ�́A�E�B���h�E�� [X] �{�^�����N���b�N���ĕ��Ă��������B
pause > nul

set retval=0
goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:set_proxy
:: �v���L�V�̐ݒ��ύX���܂��B
:: @param %1 �ݒ肷�� ProxyEnable �̒l
:: @return ���������ꍇ�� 0

set retval=1

reg add "%REG_KEY%" /v "ProxyEnable" /t REG_DWORD /d %1 /f 2> nul && (
	set retval=0
)

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:print_header
:: ��ʂ��N���A���ăw�b�_��\�����܂��B

cls
echo ============================================================
echo                   Windows �v���L�V�؂�ւ�                  
echo ============================================================
echo.

goto _return

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:_return
:: ���^�[�����܂��B

exit /b %retval%

