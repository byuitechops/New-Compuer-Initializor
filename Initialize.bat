@ECHO off
start bin/CMD.reg
TIMEOUT 2
:Cmd
echo Please don't move on until accepting the registry Changes
set /P check="Has the CMD set up finished? (Y/N): "
if %check% NEQ Y ( goto Cmd ) else ( goto CMDone )
pause
:CMDone
echo true>>"CMD"
goto node
pause
pause
:Slack
if Exist C:\Users\%USERNAME%\AppData\Local\slack\slack.exe ( goto cleanUp) else ( echo Installing Slack)
powershell -Command "Invoke-WebRequest https://slack.com/ssb/download-win64 -OutFile SlackInstall.exe"
Echo Please Wait
TIMEOUT 5
start SlackInstall.exe
:Slackn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Slack? (Y/N): "
if %check% NEQ Y (goto Slackn) else (goto cleanUp)

:Git
cmd /C "git --version" >> "temp"
set /p gitVer=<"temp"
echo %gitVer:~12,6% >> "strTemp"
set /p gitVer=<"strTemp"
del "temp"
del "strTemp"
set gitString="'git' is not recognized as an internal or external command, operable program or batch file."
cmd /C "node bin/getGit.js" >> "temp"
set /p gitSite=<"temp"
del "temp"
cmd /C "node bin/getEquals.js %gitVer% %gitSite%"
set /p checkVal=<checkVal.txt
echo %checkVal%
del checkVal.txt
if %checkVal% EQU true ( goto brackets ) else ( echo, Checking Git )
if "%gitVer%" NEQ "%gitString%" ( echo "Git was found on your computer, Update will commence"  ) else ( echo "Installing Git" )
cmd /C "node bin/getGitLink.js"
Set /P gitLink=<gitLink.txt
del gitLink.txt
echo %gitLink%
powershell -Command "Invoke-WebRequest %gitLink% -OutFile GitInstall.exe"
Echo Please Wait
TIMEOUT 5
start GitInstall.exe
:Gitn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Git? (Y/N): "
if %check% NEQ Y (goto Gitn) else (goto Brackets)

echo Nodejs.org will open, please check the current version, then enter it into the prompt.
TIMEOUT 7
:Node
start /min "Nodejs" "https://nodejs.org"
:NodeCheck
set /p ver="What is the current version of Node listed?(I.E. v7.9.0): "
set /p check="You're sure the version listed matches %ver%? (Y/N): "
if %check% NEQ Y (goto NodeCheck)
cmd /c node bin/writeLink.js %ver%
set /p URL=<node.txt
del node.txt
powershell -Command "Invoke-WebRequest " %URL% "  -OutFile NodeInstaller.msi"
Echo Please Wait
TIMEOUT 4
start NodeInstaller.msi
:Noden
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Node? (Y/N): "
if %check% NEQ Y (goto Noden) else (goto Npm)

:nodeCheerio
echo Entering nodeCheerio
Echo Please Wait
TIMEOUT 2
cmd /C "npm install cheerio"
:Cheerion
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Cheerio? (Y/N): "
if %check% NEQ Y (goto Cheerion) else (goto NodeUpdateCont)

:Npm
echo Please Wait
TIMEOUT 2
cmd /c "npm config get prefix" >> "temp"
set /p envVar=<"temp"
cmd /c "setx PATH %envVar%"
del "temp"
:Npmn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing NPM? (Y/N): "
if %check% NEQ Y (goto Npmn) else (goto Git)

:Brackets
Please Wait
TIMEOUT 2
set /p name="Enter your Name(First Last): "
set /p email="Enter your git account email: "
cmd /c git config --global user.name %name%
cmd /c git config --global user.email %email%
cmd /c git config --global core.editor "'C:/Program Files (x86)/Notepad++/notepad++.exe' -multiInst -notabbar -nosession"
cmd /c git config --global --add core.pager cat

:Bracket
cmd /C "brackets" || goto bracketsInstall
goto skipNPM

:bracketsInstall
cmd /c "node bin/getBrackets.js"
Set /P bracketsURL=<brackets.txt
del brackets.txt
powershell -Command "Invoke-WebRequest %bracketsURL% -OutFile bracketsInstaller.msi"
Echo Please Wait
TIMEOUT 3 
start bracketsInstaller.msi
:Bracketsn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Node? (Y/N): "
if %check% NEQ Y ( goto bracketsn) else goto BracketsNPM
:BracketsNPM
cmd /C "cd /D %HOMEDRIVE%\%HOMEPATH%\AppData\Roaming\Brackets\extensions\user"
cmd /C "git clone https://github.com/zaggino/brackets-npm-registry.git brackets-npm-registry"
cmd /C "cd brackets-npm-registry"
cmd /C "npm install"
:Bracketsnpmn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Brackets-NPM-Registry? (Y/N): "
if %check% NEQ Y (goto Bracketsnpmn) else (goto Slack)
:cleanUp
del NodeInstaller.msi
del GitInstall.exe
del SlackInstall.exe
del tempVar

Echo Set-up Complete! Exiting Now
TIMEOUT 3
exit