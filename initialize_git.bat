@echo off
:Git
cmd /C "git --version" >> %~dp0"temp" || goto getGit
set /p gitVer=<%~dp0"temp"
echo %gitVer:~12,6% >> %~dp0"strTemp"
set /p gitVer2=<%~dp0"strTemp"
del %~dp0"strTemp"
set gitString="'git' is not recognized as an internal or external command, operable program or batch file."
cmd /C "node %~dp0bin/getGit.js" >> %~dp0"temp"
set /p gitSite=<%~dp0"temp"
echo %gitSite:~12,6% >> %~dp0"strTemp"
set /p gitSite2=<%~dp0"strTemp"
del %~dp0"strTemp"
del %~dp0"temp"
cmd /C "node %~dp0bin/getEquals.js %gitVer2% %gitSite2%"
set /p checkVal=<checkVal.txt
del checkVal.txt
if %checkVal% EQU true ( goto brackets ) else ( echo, Checking Git )
if "%gitVer%" NEQ "%gitString%" ( echo "Git was found on your computer, Update will commence"  ) else ( echo "Installing Git" )
:getGit
cmd /C "node %~dp0bin/getGitLink.js"
Set /P gitLink=<gitLink.txt
del gitLink.txt
echo . & echo . & echo Downloading Git, this may take some time.
powershell -Command "Invoke-WebRequest %gitLink% -OutFile %~dp0GitInstall.exe"
Echo Please Wait
TIMEOUT 5
start %~dp0GitInstall.exe
:Gitn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Git? (Y/N): "
if %check% NEQ Y (goto Gitn) else ( start Initialize_Brackets.bat exit )