Write-Host "Na dit script word de pc opnieuw opgestart."
IF(-not($env:USERNAME -eq TriAdmin)){
Write-Host "U bent niet als TriAdmin ingelogd, log in als TriAdmin en probeer opnieuw."
timeout /t 5
exit
}
Read-Host -Prompt $ScriptDrive="Wat is de drive letter van deze usb?(bijv. D)"
Write-Host $ScriptDrive
Get-Partition -DriveLetter $ScriptDrive| Set-Partition -NewDriveLetter H
powershell.exe -ExecutionPolicy UnRestricted -File %ScriptDrive%\Resources\nietgebruiken.ps1
