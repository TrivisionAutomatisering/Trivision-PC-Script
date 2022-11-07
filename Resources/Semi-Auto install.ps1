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
#De-blokkeert ps1 bestanden voor windows 10
Get-ChildItem H:\Resources | Unblock-File
#Download TeamViewer
wget https://trivision.nl/downloads/TeamViewer_Host_Setup.exe -OutFile "C:\TeamViewer.exe"
#Voert TeamViewer uit
& "C:\TeamViewer.exe"
#Download ninite
wget https://ninite.com/7zip-adoptjdkx8-chrome-foxit/ninite.exe -OutFile "C:\ninite.exe"
#Voert ninite uit
& "C:\ninite.exe"
Read-Host 'Druk op Enter als TeamViewer en ninite geinstalleerd zijn.'
#Verwijderd ninite en TeamViewer bestanden
Remove-Item "C:\ninite.exe"
Remove-Item "C:\TeamViewer.exe"
#Herinstalleert teamviewer als de installatie gefaald is
#
#
#
#Start volgende deel van script
powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\Remove-HPbloatware.ps1
