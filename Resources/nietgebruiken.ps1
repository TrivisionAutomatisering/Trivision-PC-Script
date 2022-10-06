Install-Module PSWindowsUpdate
Add-WUServiceManager -MicrosoftUpdate
Get-WindowsUpdate -AcceptAll -Install
$UpdateFailed= Read-Host -Prompt "Was er een foutmelding tijdens het updaten?(ja/nee)"
if ($UpdateFailed -eq 'ja') {
    powershell -ExecutionPolicy Bypass -File H:\Resources\nietgebruiken.ps1}
elseif ($UpdateFailed -eq 'nee') {
     echo "Ok."
}
else {
      echo "Dat is een fout antwoord, het script start nu opnieuw."
      Start-Sleep -Seconds 3
      powershell -ExecutionPolicy Bypass -File H:\Resources\nietgebruiken.ps1
}
Start-Service w32time
w32tm /register
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
w32tm /resync /force
Write-Host "De tijd en datum zijn nu goed gezet."
wget https://trivision.nl/downloads/TeamViewer_Host_Setup.exe -OutFile "C:\TeamViewer.exe"
& "C:\TeamViewer.exe"
Write-Host "TeamViewer is nu aan het installeren"
timeout /t 15
wget https://ninite.com/7zip-adoptjdkx8-chrome-foxit/ninite.exe -OutFile "C:\ninite.exe"
& "C:\ninite.exe"
Write-Host "ninite is nu aan het installeren"
timeout /t 15
Remove-Item "C:\ninite.exe"
Remove-Item "TeamViewer.exe"
powershell -ExecutionPolicy Bypass -File H:\Resources\Extragebruikersjaofnee.ps1
