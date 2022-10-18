#Neemt variabele over vanuit het cmd start script
param ([string]$ScriptDrive)
#Stopt het script als de google dns niet bereikt kan worden
$InternetVerbinding = Write-Host (Test-Connection 8.8.8.8 -quiet)
if($InternetVerbinding -eq "False"){
   Write-Host "Er is geen internetverbinding"
   Timeout /t 5
   stop-process -Id $PID
}
#
Write-Host "Na dit script word de pc opnieuw opgestart."
#Verandert usb schijf letter naar H:
Get-Partition -DriveLetter $ScriptDrive | Set-Partition -NewDriveLetter H
timeout /t 5
#De-blokkeert ps1 bestanden voor windows 10
gci H:\Resources | Unblock-File
#Start volgende deel van script
powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\geenuserinput.ps1
