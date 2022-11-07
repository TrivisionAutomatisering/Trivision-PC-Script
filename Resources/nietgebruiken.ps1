# Installeert provider om windows update module te kunnen installeren
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
#Zet repository voor de windows update module als vertrouwd
Set-PSRepository PSGallery -InstallationPolicy Trusted
#Installeert module voor windows updates in powershell
Install-Module PSWindowsUpdate 
#Schakelt updates voor andere microsoft producten in
$ServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
$ServiceManager.ClientApplicationID = "My App"
$ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"") 
#Download en installeert alle windows updates
Get-WindowsUpdate -AcceptAll -Install
#Start het script opnieuw als er een foutmelding was tijdens het updaten of als er een fout antwoord gegeven is
$UpdateFailed= Read-Host -Prompt "Was er een foutmelding tijdens het updaten?(ja/nee)"
if ($UpdateFailed -eq 'ja') {
    powershell -ExecutionPolicy Bypass -File H:\Resources\nietgebruiken.ps1
}
elseif ($UpdateFailed -eq 'nee') {
    Write-Output "Ok."
}
else {
    Write-Output "Dat is een fout antwoord, dit gedeelte van het script start nu opnieuw."
    Start-Sleep -Seconds 3
    powershell -ExecutionPolicy Bypass -File H:\Resources\nietgebruiken.ps1
}
#Synct de tijd en voegt tijdservers toe
Start-Service w32time
w32tm /register
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
w32tm /resync /force
Write-Host "De tijd en datum zijn nu goed gezet."
#Gaat naar het script om office 365 te installeren
$Kop2 = 'Office 365'
$Vraag2 = 'Wil je Office 365 installeren?'
$Keuzes2 = '&Ja', '&Nee'
$Antwoord2 = $Host.UI.PromptForChoice($Kop2, $Vraag2, $Keuzes2, 1)
if ($Antwoord2 -eq 0) {
    powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\Office365.ps1
}

#Gaat naar het script om admin gebruikers toe te voegen of reboot de computer
$Kop = 'Extra Gebruiker'
$Vraag = 'Wil je een extra gebruiker toevoegen?'
$Keuzes = '&Ja', '&Nee'
$Antwoord = $Host.UI.PromptForChoice($Kop, $Vraag, $Keuzes, 1)
if ($Antwoord -eq 0) {
    powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\ExtraGebruikers.ps1
} else {
    Get-ChildItem H:\* -Include *.ps1,*.xml,*.exe -Recurse | Remove-Item -Recurse
    Get-ChildItem H:\* -Attributes Directory -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse 
    Restart-Computer
}

