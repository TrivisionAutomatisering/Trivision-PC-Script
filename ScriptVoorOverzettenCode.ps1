$NewName = Read-Host -Prompt "Wat is de naam van de PC?(bijv. WS01 of LT01)"
Rename-Computer -NewName "$NewName"
Set-TimeZone -Name "W. Europe Standard Time"
& 'H:\Resources\Ninite.exe'
TAKEOWN /f C:\Windows.old\*.*
ICACLS C:\Windows.old\*.* /Grant 'System:(F)'
Remove-Item C:\Windows.old\*.*
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
