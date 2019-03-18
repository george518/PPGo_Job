@shift 1
@echo off
@title PPGoJob服务
color 0A

chcp 65001

set curPath=%~dp0

:welcome
cls
echo.
echo    1.启动
echo    2.停止
echo    3.重启
echo.
set /p input= 请输入代码(选1/2/3 直接回车)：
if not "%input%"=="" SET input=%input:~0,1%
if "%input%"=="1" goto start
if "%input%"=="2" goto stop
if "%input%"=="3" goto restart
cls
echo.
echo    选择无效,按任意键返回菜单
echo.
echo    现在是：%date% %time%
@pause >nul
goto welcome

:start
start "PPGo_Job" /min PPGo_Job.exe
echo 服务已启动...
pause
exit

:stop
taskkill /f /t /im PPGo_Job.exe
echo 服务已停止...
pause
exit

:restart
taskkill /f /t /im PPGo_Job.exe
start "PPGo_Job" /min PPGo_Job.exe
echo 服务已重启...
pause
exit