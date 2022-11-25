@echo off
set /p "ScriptDrive=Wat is de schijf letter van de usb?(bijv. D)(zonder :)"
md %ScriptDrive%:\Temp
curl -o "%ScriptDrive%:\Temp\test.ps1" https://raw.githubusercontent.com/MitchellTrivision/Trivision-PC-Script/main/test.ps1
powershell.exe -ExecutionPolicy Unrestricted -File Unblock-File %ScriptDrive%:\Temp\test.ps1
powershell.exe -ExecutionPolicy UnRestricted -File "%ScriptDrive%:\Temp\test.ps1" "%ScriptDrive%"