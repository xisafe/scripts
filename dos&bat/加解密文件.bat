@echo off
Title  BAT����                                                                                          By ��˭Ϊʦ



rem ======== ���ñ���


set L0=	 				BAT����/����   
set L1=.
set L2=		 �q�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�r
set l3= 	 �U                                   			     �U
set l4=  	�t�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�s	
set l5=	 	 �U			��1�� ����		    	     �U
set l6=	 	 �U			��2�� ����			     �U
s
:head
cls
mode con: cols=80 lines=25 &color 1f
echo%L1%&&echo%L1%&&echo%L0%&&echo%L1%&&echo%L2%&&echo%L3%&&echo%L3%&&echo%L5%&&echo%L3%&&echo%L6%&&echo%L3%&&echo%L3%&&echo%L4%
ver|Findstr /i "xp">Nul
if %errorLevel% equ 0 ( set l=xps
)else (goto  :win7)
set /p ch="��������� Ȼ�󰴻س���"
IF "%ch%"=="" Goto :head
IF Not "%ch%"=="" SET ch=%ch:~0,1%
if /i %ch%==1 goto :encrypt
if /i %ch%==2 goto :decode

:win7
choice /c 12 /n /m "���������:"
if %errorlevel%==1 goto :encrypt
if %errorlevel%==2 goto :decode




:encrypt
rem ======== ���м���
set /p file=��������Ҫ�����������س���(q=�˳�):
if "%file%"=="q" goto quit
echo %file%|findstr /i "\.bat$">nul && goto go
echo %file%|findstr /i "\.cmd$">nul && goto go
cls
echo ==============
echo ����ȷ����!
echo ==============
echo.
echo.
echo ���������������......
pause>nul
goto :head
:go
if not exist "%file%" goto newly
if exist encrypt.bat copy encrypt.bat encryptbak.bat
echo %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a %%%%a >"%tmp%\encrypt.tmp"
echo cls>>"%tmp%\encrypt.tmp"
type "%file%">>"%tmp%\encrypt.tmp"
setlocal enabledelayedexpansion
for %%i in ("%tmp%\encrypt.tmp") do (
echo %%~zi >nul 2>nul
set size=%%~zi
set num=!size:~-1!
set /a mod=!num!%%2
if !mod! equ 0 (goto even) else (goto odd)
)
:even
copy "%tmp%\encrypt.tmp" encrypt.bat
del "%tmp%\encrypt.tmp"
cls
echo ==========================
echo ��ϲ, ��������ܳɹ�^^!
echo ==========================
echo.
echo.
echo ��������˳�......
pause>nul
goto quit
:odd
echo. >>"%tmp%\encrypt.tmp"
copy "%tmp%\encrypt.tmp" encrypt.bat
del "%tmp%\encrypt.tmp"
cls
echo ==========================
echo ��ϲ, ��������ܳɹ�^^!
echo ==========================
echo.
echo.
echo ��������˳�......
pause>nul
goto quit
:newly
cls
echo ================================
echo ���������ļ�, ����������!
echo ================================
echo.
echo.
echo ���������ʼ......
pause>nul
goto start
:quit
exit




:decode
rem ======== ���н���
set route=%cd%
set ravel=
set /p ravel=      ������Ҫ���ܵ�������:
set "ravel=%ravel:"=%"
if /i "%ravel:~-4%"==".bat" if exist "%ravel%" goto go2
if /i "%ravel:~-4%"==".cmd" if exist "%ravel%" goto go2
cls
echo                              �q���������������������r
echo          �q��������������������      �� �� �� ��     �������������������r
echo          ��                   �t���������������������s                  ��
echo          ��                                                             ��
echo          ��      ָ���ļ������ڻ��ļ���������������!                    ��
echo          ��                                                             ��
echo          ��      ���������������...                                    ��
echo          ��                                                             ��
echo          �t�������������������������������������������������������������s
echo.
echo.
echo ���������������...
pause >nul
goto :head

:go2
for /f "tokens=*" %%c in ("%ravel%") do (
     cd /d "%%~dpc"
     if exist "%route%\new_%%~nxc" attrib -s -h -r -a "%route%\new_%%~nxc"
     echo author:pengfei@www.cn-dos.net>"%route%\new_%%~nxc"
     for /f "tokens=*" %%i in (%%~nxc) do (
       echo %%i>>"%route%\new_%%~nxc"
     )
)
cls
echo                              �q���������������������r
echo          �q��������������������      �� �� �� ��     �������������������r
echo          ��                   �t���������������������s                 ��
echo          ��                                                           ��
echo          ��      ��ϲ, ��������ܳɹ�!                                 ��
echo          ��                                                           ��
echo          �t�����������������������������������������������������������s
echo.
echo.
echo ��������˳�...
pause >nul
exit