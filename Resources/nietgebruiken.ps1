$ScriptDrive= Read-Host -Prompt "Wat is de schijf letter van deze usb?(bijv X:)"
ECHO "De schijf letter is $ScriptDrive"
Install-Module PSWindowsUpdate
Get-WindowsUpdate -AcceptAll -Install
$UpdateFailed= Read-Host -Prompt "Was er een foutmelding tijdens het updaten?(ja/nee)"
if ($UpdateFailed -eq 'ja') {
    powershell -ExecutionPolicy Bypass -File $ScriptDrive\Resources\nietgebruiken.ps1}
elseif ($UpdateFailed -eq 'nee') {
     echo "Ok."
}
else {
      echo "Dat is een fout antwoord, het script start nu opnieuw."
      Start-Sleep -Seconds 3
      powershell -ExecutionPolicy Bypass -File $ScriptDrive\Resources\nietgebruiken.ps1
}
Start-Service w32time
w32tm /register
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
w32tm /resync /force
Write-Host "De tijd en datum zijn nu goed gezet."
wget https://trivision.nl/downloads/TeamViewer_Host_Setup.exe -OutFile "C:\TeamViewer.exe"
& "C:\TeamViewer.exe"
powershell -ExecutionPolicy Bypass -File $ScriptDrive\Resources\Extragebruikersjaofnee.ps1
