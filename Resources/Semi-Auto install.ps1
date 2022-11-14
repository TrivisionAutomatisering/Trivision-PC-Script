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
Invoke-WebRequest https://trivision.nl/downloads/TeamViewer_Host_Setup.exe -OutFile "C:\TeamViewer.exe"
#Voert TeamViewer uit
& "C:\TeamViewer.exe"
#Download ninite
Invoke-WebRequest https://ninite.com/7zip-adoptjdkx8-chrome-foxit/ninite.exe -OutFile "C:\ninite.exe"
#Voert ninite uit
& "C:\ninite.exe"
Read-Host 'Druk op Enter als TeamViewer en ninite geinstalleerd zijn.'
#Verwijderd ninite en TeamViewer bestanden
Remove-Item "C:\ninite.exe"
Remove-Item "C:\TeamViewer.exe"
#Herinstalleert teamviewer als de installatie gefaald is
$Kop = 'TeamViewer'
$Vraag = 'Is TeamViewer Correct Geinstalleerd?'
$Keuzes = '&Ja', '&Nee'
$Antwoord = $Host.UI.PromptForChoice($Kop, $Vraag, $Keuzes, 1)
if ($Antwoord -eq 0) {
   Taskkill /F /IM TeamViewer.exe
   start "C:\Program Files (x86)\TeamViewer\uninstall.exe" /S 
   wget https://trivision.nl/downloads/TeamViewer_Host_Setup.exe -OutFile "C:\TeamViewer.exe"
   start /wait TeamViewer_Host_Setup.exe /S /norestart
}
#Start volgende deel van script
powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\Remove-HPbloatware.ps1
