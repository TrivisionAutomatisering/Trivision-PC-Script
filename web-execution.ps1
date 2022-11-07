#Neemt variabele over vanuit het cmd start script
param ([string]$ScriptDrive)
#Verandert usb schijf letter naar H:
Get-Partition -DriveLetter $ScriptDrive | Set-Partition -NewDriveLetter H
mkdir C:\Temp -ErrorAction Ignore
Invoke-WebRequest https://github.com/MitchellTrivision/Trivision-PC-Script/releases/latest/download/PcScript.zip -OutFile C:\Temp\PcScript.zip
Expand-Archive C:\Temp\PcScript.zip -DestinationPath H:\ -Force
Remove-Item "C:\Temp" -Recurse
Unblock-File "H:/*.ps1"
powershell.exe -ExecutionPolicy UnRestricted -File "H:\Resources\Semi-Auto install.ps1"
