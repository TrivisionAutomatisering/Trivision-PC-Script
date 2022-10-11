#Installeert module voor windows updates in powershell
Install-Module PSWindowsUpdate -Confirm:$False
#Schakelt updates voor andere microsoft producten in
$ServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
$ServiceManager.ClientApplicationID = "My App"
$NewService = $ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"") -Confirm:$False
#Download en installeert alle windows updates
Get-WindowsUpdate -AcceptAll -Install
#Start het script opnieuw als er een foutmelding was tijdens het updaten of als er een fout antwoord gegeven is
$UpdateFailed= Read-Host -Prompt "Was er een foutmelding tijdens het updaten?(ja/nee)"
if ($UpdateFailed -eq 'ja') {
    powershell -ExecutionPolicy Bypass -File H:\Resources\nietgebruiken.ps1}
elseif ($UpdateFailed -eq 'nee') {
     echo "Ok."
}
else {
      echo "Dat is een fout antwoord, dit gedeelte van het script start nu opnieuw."
      Start-Sleep -Seconds 3
      powershell -ExecutionPolicy Bypass -File H:\Resources\nietgebruiken.ps1
}
#Synct de tijd en voegt tijdservers toe
Start-Service w32time
w32tm /register
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
w32tm /resync /force
Write-Host "De tijd en datum zijn nu goed gezet."
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
#Gaat naar het script om te vragen voor evt extra admin gebruikers
powershell -ExecutionPolicy Bypass -File H:\Resources\Extragebruikersjaofnee.ps1
