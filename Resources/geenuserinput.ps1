#Verandert systeem naam
$NewName = Read-Host -Prompt "Wat is de naam van de PC?(bijv. WS01 of LT01)"
Rename-Computer -NewName "$NewName"
#Schakelt BitLocker in en output bestand met id en herstelsleutel naar txt bestand op usb stick
Enable-BitLocker -MountPoint "C:" -RecoveryPasswordProtector
Start-Sleep 2
(Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object RecoveryPassword | Select-Object KeyProtectorId, RecoveryPassword > H:/BitlockerKey$NewName.txt
#Verandert tijdzone
tzutil /s "W. Europe Standard Time"
#Verwijdert Windows.old
TAKEOWN /f C:\Windows.old\*.*
ICACLS C:\Windows.old\*.* /Grant 'System:(F)'
Remove-Item C:\Windows.old\*.*
#Zet UAC uit
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
#Start volgende script
powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\nietgebruiken.ps1
