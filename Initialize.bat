@ECHO off
::for /f %%i in ("CMD") do set size=%%~zi
::if %size% gtr 0 ( set /p tempVar=<"CMD" ) else ( set tempVar=False)
::if %tempVar% EQU true ( goto node ) else (echo Updating CMD)
:Echo Please Wait
::TIMEOUT 3
Echo Starting up!
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

:Node
cmd /C "node -v" >> "temp" || goto nodeCrash
:nodeCrash
for /f %%i in ("temp") do set size=%%~zi
if %size% EQU 0 ( goto setNode  ) else ( goto nodeSetTemp)
:nodeSetTemp
set /p ver=<"temp" 
:nodeVer
del "temp."
set string="'node' is not recognized as an internal or external command, operable program or batch file."
if %ver% NEQ %string% ( goto nodeUpdate) else ( goto nodeFreshUp )

:nodeUpdate
echo "Node was found on your computer, Update will commence"
:nodeUpdateCont
cmd /C "node bin/getLink.js" || goto nodeCheerio
echo Entering nodeUpdateCont
Set /P version=<node.txt
Set /p vers=<nodeVer.txt
del node.txt
del nodeVer.txt 
set mypath=%cd%
powershell -Command "Invoke-WebRequest %version% -OutFile nodeInstaller.msi"
Echo Please Wait
TIMEOUT 4
start NodeInstaller.msi
:Noden
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Node? (Y/N): "
if %check% NEQ Y (goto Noden) else (goto Npm)

:nodeFreshUp
powershell -Command "Invoke-WebRequest https://nodejs.org/dist/v7.8.0/node-v7.8.0-x64.msi -OutFile NodeInstaller.msi"
Echo Please Wait
TIMEOUT 3 
start nodeInstaller.msi
:NodeFn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Node? (Y/N): "
if %check% NEQ Y (goto NodeFn) else (goto Npm)
pause
goto Npm

:setNode
set ver="'node' is not recognized as an internal or external command, operable program or batch file."
goto nodeVer

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
cmd /C "cd /D %HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Brackets\extensions\user"
cmd /C "git clone https://github.com/zaggino/brackets-npm-registry.git brackets-npm-registry"
cmd /C "cd brackets-npm-registry"
cmd /C "npm install"
:Bracketsn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Brackets-NPM-Registry? (Y/N): "
if %check% NEQ Y (goto Bracketsn) else (goto Slack)

:cleanUp
del NodeInstaller.msi
del GitInstall.exe
del SlackInstall.exe
del tempVar

Echo Set-up Complete! Exiting Now
TIMEOUT 3
exit
