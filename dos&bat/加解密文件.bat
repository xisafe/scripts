@echo off
Title  BAT工具                                                                                          By 以谁为师



rem ======== 设置变量


set L0=	 				BAT加密/解密   
set L1=.
set L2=		 ╭═════════════════════════════╮
set l3= 	 ║                                   			     ║
set l4=  	╰══════════════════════════════╯	
set l5=	 	 ║			【1】 加密		    	     ║
set l6=	 	 ║			【2】 解密			     ║
s
:head
cls
mode con: cols=80 lines=25 &color 1f
echo%L1%&&echo%L1%&&echo%L0%&&echo%L1%&&echo%L2%&&echo%L3%&&echo%L3%&&echo%L5%&&echo%L3%&&echo%L6%&&echo%L3%&&echo%L3%&&echo%L4%
ver|Findstr /i "xp">Nul
if %errorLevel% equ 0 ( set l=xps
)else (goto  :win7)
set /p ch="请输入序号 然后按回车："
IF "%ch%"=="" Goto :head
IF Not "%ch%"=="" SET ch=%ch:~0,1%
if /i %ch%==1 goto :encrypt
if /i %ch%==2 goto :decode

:win7
choice /c 12 /n /m "请输入序号:"
if %errorlevel%==1 goto :encrypt
if %errorlevel%==2 goto :decode




:encrypt
rem ======== 进行加密
set /p file=请输入需要加密批处理按回车键(q=退出):
if "%file%"=="q" goto quit
echo %file%|findstr /i "\.bat$">nul && goto go
echo %file%|findstr /i "\.cmd$">nul && goto go
cls
echo ==============
echo 请正确输入!
echo ==============
echo.
echo.
echo 按任意键重新输入......
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
echo 恭喜, 批处理加密成功^^!
echo ==========================
echo.
echo.
echo 按任意键退出......
pause>nul
goto quit
:odd
echo. >>"%tmp%\encrypt.tmp"
copy "%tmp%\encrypt.tmp" encrypt.bat
del "%tmp%\encrypt.tmp"
cls
echo ==========================
echo 恭喜, 批处理加密成功^^!
echo ==========================
echo.
echo.
echo 按任意键退出......
pause>nul
goto quit
:newly
cls
echo ================================
echo 找批处理文件, 请重新输入!
echo ================================
echo.
echo.
echo 按任意键开始......
pause>nul
goto start
:quit
exit




:decode
rem ======== 进行解密
set route=%cd%
set ravel=
set /p ravel=      请输入要解密的批处理:
set "ravel=%ravel:"=%"
if /i "%ravel:~-4%"==".bat" if exist "%ravel%" goto go2
if /i "%ravel:~-4%"==".cmd" if exist "%ravel%" goto go2
cls
echo                              ╭──────────╮
echo          ╭─────────┤      文 件 错 误     ├────────╮
echo          │                   ╰──────────╯                  │
echo          │                                                             │
echo          │      指定文件不存在或文件不是批处理类型!                    │
echo          │                                                             │
echo          │      按任意键重新输入...                                    │
echo          │                                                             │
echo          ╰──────────────────────────────╯
echo.
echo.
echo 按任意键重新输入...
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
echo                              ╭──────────╮
echo          ╭─────────┤      解 密 成 功     ├────────╮
echo          │                   ╰──────────╯                 │
echo          │                                                           │
echo          │      恭喜, 批处理解密成功!                                 │
echo          │                                                           │
echo          ╰─────────────────────────────╯
echo.
echo.
echo 按任意键退出...
pause >nul
exit