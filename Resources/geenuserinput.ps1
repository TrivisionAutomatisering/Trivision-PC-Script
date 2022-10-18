#Schakelt BitLocker in op de C schijfals dit niet ingeschakeld is
if(((Get-BitLockerVolume | Where-Object -Property MountPoint -Contains C:).ProtectionStatus) -eq 'Off'){
Enable-BitLocker -MountPoint "C:" -RecoveryPasswordProtector
}
#Slaat specs en bitlocker op als variabele
$Model = Get-ComputerInfo CsModel | Select -ExpandProperty CsModel
$CPU = Get-ComputerInfo CsProcessors | Select -ExpandProperty CsProcessors | Select -ExpandProperty Name
$SerieNummer = Get-ComputerInfo BiosSeralnumber | Select -ExpandProperty BiosSeralNumber
$SchijfNaam = Get-Disk | Where-Object -Property Number -Contains 0 | Select -ExpandProperty FriendlyName
$SchijfGrootte = Write-Host ([math]::Round((get-disk -number 0 | Select -ExpandProperty Size)/1073741824)) GB
$TotaalGeheugen = [math]::Round((Get-CimInstance -Class CIM_PhysicalMemory -ErrorAction Stop | Select -ExpandProperty Capacity)/1073741824)
$GeheugenMHZ = Get-CimInstance -Class CIM_PhysicalMemory -ErrorAction Stop | Select -ExpandProperty Speed
$VolledigeRamInfo = Write-Host $TotaalGeheugen GB  "@" $GeheugenMHZ MHZ
$BitLockerID = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object RecoveryPassword | Select -ExpandProperty KeyProtectorId
$BitLockerSleutel = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object RecoveryPassword | Select -ExpandProperty RecoveryPassword
#Verandert systeem naam
$NewName = Read-Host -Prompt "Wat is de naam van de PC?(bijv. WS01 of LT01)"
Rename-Computer -NewName "$NewName"
#Output bitlocker id, bitlocker key, PC model, CPU, serienummer en drive info naar een tekst bestand
$specs = New-Object psobject
$specs | Add-Member -MemberType NoteProperty -Name Model -Value $Model
$specs | Add-Member -MemberType NoteProperty -Name CPU -Value $CPU
$specs | Add-Member -MemberType NoteProperty -Name SerieNummer -Value $SerieNummer
$specs | Add-Member -MemberType NoteProperty -Name SchijfNaam -Value $SchijfNaam
$specs | Add-Member -MemberType NoteProperty -Name SchijfGrootte -Value $SchijfGrootte
$specs | Add-Member -MemberType NoteProperty -Name RAMInfo -Value $VolledigeRamInfo
$specs | Add-Member -MemberType NoteProperty -Name BitLockerID -Value $BitLockerID
$specs | Add-Member -MemberType NoteProperty -Name BitLockerHerstelSleutel -Value $BitLockerSleutel
$specs | Export-Csv H:\PcInfo$NewName.csv -NoTypeInformation
#Verandert tijdzone
tzutil /s "W. Europe Standard Time"
#Verwijdert Windows.old
if (Test-Path -Path 'C:\Windows.old' -PathType Container){
TAKEOWN /f C:\Windows.old\*.*
ICACLS C:\Windows.old\*.* /Grant 'System:(F)'
Remove-Item C:\Windows.old\*.*
}
#Zet UAC uit
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
#Start volgende script
powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\nietgebruiken.ps1
