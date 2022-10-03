@echo off
echo "Na dit script word de pc opnieuw opgestart."
IF NOT %username%==TriAdmin (echo "U bent niet als TriAdmin ingelogd, log in als TriAdmin en probeer opnieuw." & timeout /t 5 & exit)
set /p ScriptDrive="Wat is de drive letter van deze usb?(bijv. X:)"
echo %ScriptDrive%
powershell.exe -ExecutionPolicy UnRestricted -File %ScriptDrive%\Resources\nietgebruiken.ps1
