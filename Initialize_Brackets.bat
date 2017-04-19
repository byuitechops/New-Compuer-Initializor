@echo off
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
if Exist "C:\Program Files (x86)\Brackets" (echo Brackets is Installed) else (goto bracketsInstall)
goto BracketsNPM

:bracketsInstall
echo install 
cmd /c "node %~dp0bin\getBrackets.js"
Set /P bracketsURL=<brackets.txt
del brackets.txt
powershell -Command "Invoke-WebRequest %bracketsURL% -OutFile %~dp0bracketsInstaller.msi"
Echo Please Wait
TIMEOUT 3 
start %~dp0bracketsInstaller.msi
:Bracketsn
echo Please don't move on until completeting the Installer
set /P check="Have you finished installing Brackets? (Y/N): "
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
del %~dp0bracketsInstaller.msi
del %~dp0NodeInstaller.msi
del %~dp0GitInstall.exe
del %~dp0SlackInstall.exe
del %~dp0"temp"

Echo Set-up Complete! Exiting Now
TIMEOUT 9
exit