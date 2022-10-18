@echo off
set /p "ScriptDrive=Wat is de schijf letter van de usb?(bijv. D)(zonder :)"
Unblock-File "%ScriptDrive%:\Resources\Semi-Auto install.ps1"
powershell.exe -ExecutionPolicy UnRestricted -File "%ScriptDrive%:\Resources\Semi-Auto install.ps1" "%ScriptDrive%"
