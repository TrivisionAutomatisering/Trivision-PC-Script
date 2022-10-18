@echo off
set /p "ScriptDrive=Wat is de schijf letter van de usb?(bijv. D)(zonder :)"
powershell.exe gci -Path %ScriptDrive%:\ -Depth 1 | Unblock-File
powershell.exe -ExecutionPolicy UnRestricted -File "%ScriptDrive%:\Resources\Semi-Auto install.ps1" "%ScriptDrive%"
