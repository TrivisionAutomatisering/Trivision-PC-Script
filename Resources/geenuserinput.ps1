$NewName = Read-Host -Prompt "Wat is de naam van de PC?(bijv. WS01 of LT01)"
Rename-Computer -NewName "$NewName"
Enable-BitLocker -MountPoint "C:" -RecoveryPasswordProtector
Start-Sleep 2
(Get-BitLockerVolume -MountPoint C).KeyProtector > H:/BitlockerKey$NewName.txt
tzutil /s "W. Europe Standard Time"
TAKEOWN /f C:\Windows.old\*.*
ICACLS C:\Windows.old\*.* /Grant 'System:(F)'
Remove-Item C:\Windows.old\*.*
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\nietgebruiken.ps1
