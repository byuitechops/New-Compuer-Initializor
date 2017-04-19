@echo off
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
if %check% NEQ Y (goto Cheerion) else ( starzt %~dp0Initialize_git.bat exit )