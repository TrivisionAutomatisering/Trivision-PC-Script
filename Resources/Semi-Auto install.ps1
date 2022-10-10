param ([string]$ScriptDrive)
Write-Host "Na dit script word de pc opnieuw opgestart."
Get-Partition -DriveLetter $ScriptDrive | Set-Partition -NewDriveLetter H
timeout /t 5
powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\geenuserinput.ps1