@echo off
set /p "ScriptDrive=Wat is de schijf letter van de usb?(bijv. D)(zonder :)"
curl -o "%ScriptDrive%:\web-execution.ps1" https://raw.githubusercontent.com/MitchellTrivision/Trivision-PC-Script/main/test.ps1
powershell.exe -ExecutionPolicy Unrestricted -File Unblock-File "%ScriptDrive%:\web-execution.ps1"
powershell.exe -ExecutionPolicy UnRestricted -File "%ScriptDrive%:\web-execution.ps1" "%ScriptDrive%"