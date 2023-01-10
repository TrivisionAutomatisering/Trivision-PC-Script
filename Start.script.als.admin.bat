@echo off
echo Hier is een lijst met aangesloten drives
wmic logicaldisk get deviceid, volumename, description
set /p "ScriptDrive=Wat is de schijf letter van de usb?(bijv. D)(zonder :)"
curl -o %ScriptDrive%:\test.ps1 https://raw.githubusercontent.com/TrivisionAutomatisering/Trivision-PC-Script/main/test.ps1
powershell.exe -ExecutionPolicy Unrestricted -File Unblock-File "%ScriptDrive%:\test.ps1"
powershell.exe -ExecutionPolicy UnRestricted -File "%ScriptDrive%:\test.ps1" "%ScriptDrive%"
