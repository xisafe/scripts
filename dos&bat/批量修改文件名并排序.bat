@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
COLOR 0A
TITLE �����޸��ļ���������
ECHO.
ECHO =================================
ECHO     ��ӭʹ��keith������������
ECHO =================================
ECHO.
ECHO ��ѡ��Ҫ�����޸ĵĴ���ĺ�׺����
ECHO.
ECHO 1. �����ļ�(ֻ���޸��ļ���)
ECHO 2. txt
ECHO 3. png
ECHO 4. ����,���Լ�������
ECHO.
CHOICE /C 1234 /m "���ѡ����: "
IF %ERRORlEVEL% equ 1 SET suffix=*
IF %ERRORlEVEL% equ 2 SET suffix=txt
IF %ERRORlEVEL% equ 3 SET suffix=png
IF %ERRORlEVEL% equ 4 (
ECHO.
SET /P suffix="������Ҫ��������ĺ�׺��: "
)
ECHO.
SET /p prefix="���������޸ĳɵ��ļ����Ŀ�ͷ: "
ECHO.
ECHO �޸�ing...
ECHO.
SET /a index=0
FOR %%i in (*.!suffix!) do (
    SET /a index=!index!+1
    SET name=!prefix!!index!.!suffix!
    REN "%%i" !name!
)
IF %ERRORlEVEL% equ 0 (
    ECHO �޸ĳɹ�!
) ELSE (
    ECHO �޸�ʧ��!
)
ECHO.
PAUSE