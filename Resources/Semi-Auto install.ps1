#Neemt variabele over vanuit het cmd start script
param ([string]$ScriptDrive)
Write-Host "Na dit script word de pc opnieuw opgestart."
#Verandert usb schijf letter naar H:
Get-Partition -DriveLetter $ScriptDrive | Set-Partition -NewDriveLetter H
timeout /t 5
#Start volgende deel van script
powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\geenuserinput.ps1
