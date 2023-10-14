@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :runScript
) else (
    goto :getAdmin
)

:getAdmin
echo Script is elevating itself...
pushd "%CD%" 
CD /D "%~dp0" 
set vbs="%temp%\getadmin.vbs"

echo Set UAC = CreateObject^("Shell.Application"^)                > "%vbs%"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%vbs%"

cscript "%vbs%"
del "%vbs%"
exit /b

:runScript
echo by @SamirJunaid
echo.
echo List of Modern Apps:
echo ---------------------
set psScript="%temp%\tmpScript.ps1"
echo Get-AppxPackage -AllUsers ^| Where-Object {$_.IsFramework -eq $false -and $_.Name -notlike '*Microsoft*' -and $_.InstallLocation -notlike '*system32*'} ^| ForEach-Object { "$($_.Name) - $($_.InstallLocation)" } > %psScript%
powershell -ExecutionPolicy Bypass -File %psScript%
del %psScript%

echo.
echo List of Traditional Apps:
echo ---------------------
for /f "delims=" %%i in ('WMIC product get name ^| findstr /V /I "windows microsoft"') do echo %%i

pause
