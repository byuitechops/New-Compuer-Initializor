@ECHO off
start %~dp0bin/CMD.reg
TIMEOUT 2
:Cmd
echo Please don't move on until accepting the registry Changes
set /P check="Has the CMD set up finished? (Y/N): "
if %check% NEQ Y ( goto Cmd ) else ( goto CMDone )
pause
:CMDone
echo true>>%~dp0"CMD"
goto node
pause

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
echo . & echo . & echo . & echo . & echo . & echo Downloading Git, this may take some time.
powershell -Command "Invoke-WebRequest %gitLink% -OutFile %~dp0GitInstall.exe"
Echo Please Wait
TIMEOUT 5
start %~dp0GitInstall.exe
:Gitn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Git? (Y/N): "
if %check% NEQ Y (goto Gitn) else (goto Brackets)

:nodeError
echo It appears the version number you entered was incorrect, please check the website and try again.
TIMEOUT 7
goto Node
:Node
echo Nodejs.org will open, please check the current version on their website, then enter it into the prompt. It should be located next to the word "Current".
TIMEOUT 9
start "Nodejs" "https://nodejs.org"
:NodeCheck
set /p ver="What is the current version of Node listed on the Nodejs website?(ex v7.9.0): "
set /p check="You're sure the version listed matches %ver%? (Y/N): "
if %check% NEQ Y (goto NodeCheck)
cmd /C "node -v" >> %~dp0"temp" || goto dowNode
set /p nodeVer=<%~dp0"temp"
del %~dp0"temp"
if %nodeVer% NEQ %ver% ( goto dowNode ) else ( start %~dp0Initialize_NPM.bat exit )
:dowNode
echo https://nodejs.org/dist/%ver%/node-%ver%-x64.msi >> %~dp0"temp"
set /p URL=<%~dp0"temp"
del %~dp0"temp"
powershell -Command "Invoke-WebRequest " %URL% " -OutFile %~dp0NodeInstaller.msi"
Echo Please Wait
TIMEOUT 4
start %~dp0NodeInstaller.msi
:Noden
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Node? (Y/N): "
if %check% NEQ Y ( goto Noden ) else ( start %~dp0Initialize_NPM.bat exit )

:Npm
echo Please Wait for Node to initialize
TIMEOUT 7
cmd /c "npm config get prefix" >> %~dp0"temp"
set /p envVar=<%~dp0"temp"
cmd /c "setx PATH %envVar%"
del %~dp0"temp"
:Npmn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing NPM? (Y/N): "
if %check% NEQ Y (goto Npmn) else (goto nodeCheerio)

:nodeCheerio
echo Entering nodeCheerio
Echo Please Wait
TIMEOUT 2
cmd /C "npm install --prefix %~dp0 cheerio"
:Cheerion
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Cheerio? (Y/N): "
if %check% NEQ Y (goto Cheerion) else (goto Git)

:Brackets
cmd /c "start %~dp0Initialize_II.bat"
exit
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
goto BracketsNPM

:bracketsInstall
cmd /c "node %~dp0bin/getBrackets.js"
Set /P bracketsURL=<%~dp0bin/brackets.txt
del %~dp0bin/brackets.txt
powershell -Command "Invoke-WebRequest %bracketsURL% -OutFile %~dp0bracketsInstaller.msi"
Echo Please Wait
TIMEOUT 3 
start %~dp0bracketsInstaller.msi
:Bracketsn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Node? (Y/N): "
if %check% NEQ Y ( goto bracketsn) else goto BracketsNPM
:BracketsNPM
move "%~dp0bin\brackets.json" "C:\Users\%USERNAME%\AppData\Roaming\Brackets"
cmd /C "cd /D %HOMEDRIVE%\%HOMEPATH%\AppData\Roaming\Brackets\extensions\user"
cmd /C "git clone https://github.com/zaggino/brackets-npm-registry.git brackets-npm-registry"
cmd /C "cd brackets-npm-registry"
cmd /C "npm install --prefix %~dp0"
:Bracketsnpmn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Brackets-NPM-Registry? (Y/N): "
if %check% NEQ Y (goto Bracketsnpmn) else (goto Slack)

:Slack
if Exist C:\Users\%USERNAME%\AppData\Local\slack\slack.exe ( goto cleanUp ) else ( echo Installing Slack )
powershell -Command "Invoke-WebRequest https://slack.com/ssb/download-win64 -OutFile %~dp0SlackInstall.exe"
Echo Please Wait
TIMEOUT 5
start %~dp0SlackInstall.exe
:Slackn
echo Please don't move on until completeting the Installer, This one is particularly lengthy.
set /P check="Have you finished installing Slack? (Y/N): "
if %check% NEQ Y (goto Slackn) else (goto cleanUp)

:cleanUp
del %~dp0NodeInstaller.msi
del %~dp0GitInstall.exe
del %~dp0SlackInstall.exe
del %~dp0tempVar

Echo Set-up Complete! Exiting Now
TIMEOUT 7
exit
