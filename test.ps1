#Neemt variabele over vanuit het cmd start script
param ([string]$ScriptDrive)
#
Set-ExecutionPolicy Restricted
#Requires -RunAsAdministrator

#Verandert usb schijf letter naar H:
Get-Partition -DriveLetter $ScriptDrive | Set-Partition -NewDriveLetter H
#

## Windows Update Script
#Windows Update ScriptBlock
$WindowsUpdate = {
# Installeert provider om windows update module te kunnen installeren
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
#Zet repository voor de windows update module als vertrouwd
Set-PSRepository PSGallery -InstallationPolicy Trusted
#Installeert module voor windows updates in powershell
Install-Module PSWindowsUpdate
Import-Module PSWindowsUpdate
#Download en installeert alle windows updates 2 keer
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot -ignoreRebootRequired
$KopWindowsUpdate = 'Windows Update'
$VraagWindowsUpdate = 'Was er een fout tijdens het updaten?'
$KeuzesWindowsUpdate = '&Ja', '&Nee'
$AntwoordWindowsUpdate = $Host.UI.PromptForChoice($KopWindowsUpdate, $VraagWindowsUpdate, $KeuzesWindowsUpdate, 1)
if($AntwoordWindowsUpdate -eq 0){
    & $WindowsUpdate
}
}
##

##Office Script
#Office ScriptBlock installeert office met dezelfde taal als de OS
$Office365 = {
    mkdir C:\Temp -ErrorAction Ignore
    Invoke-WebRequest https://github.com/MitchellTrivision/Trivision-PC-Script/releases/latest/download/Office365.zip -OutFile C:\Temp\Office365.zip
    Expand-Archive C:\Temp\Office365.zip -DestinationPath H:\ -Force
    Remove-Item "C:\Temp" -Recurse
    H:\setup.exe /configure "H:\Office nl-NL x64.xml"
}
#Vraagt of office geinstalleerd moet worden
$KopOffice = 'Office 365'
$VraagOffice = 'Wil je Office 365 installeren?'
$KeuzesOffice = '&Ja', '&Nee'
$AntwoordOffice = $Host.UI.PromptForChoice($KopOffice, $VraagOffice, $KeuzesOffice, 1)
##

##Extra Gebruiker Script
# ScriptBlock dat vraagt naar gegevens voor de gebruiker, de gebruiker aanmaakt, toevoegt aan admin en dan vraagt of er nog een gebruiker toegevoegd moet worden.
$KopGebruiker = 'Extra Gebruiker'
$VraagGebruiker = 'Wil je een extra gebruiker toevoegen?'
$KeuzesGebruiker = '&Ja', '&Nee'
$AntwoordGebruiker = $Host.UI.PromptForChoice($KopGebruiker, $VraagGebruiker, $KeuzesGebruiker, 1)
$ExtraGebruiker = {
    $UserName = Read-Host -Prompt "Wat is de gebruikersnaam?"
    $UserPswd = Read-Host -Prompt "Wat is het wachtwoord?"
    $UserFullName = Read-Host -Prompt "Wat is de volledige naam?"
    $secureString = ConvertTo-SecureString $UserPswd -asplaintext -Force
    New-LocalUser -Name "$UserName" -Password $secureString -FullName "$UserFullName"
    Add-LocalGroupMember -Group "Administrators" -Member "$UserName"
    $KopGebruiker = 'Extra Gebruiker'
    $VraagGebruiker = 'Wil je nog een gebruiker toevoegen?'
    $KeuzesGebruiker = '&Ja', '&Nee'
    $AntwoordGebruiker = $Host.UI.PromptForChoice($KopGebruiker, $VraagGebruiker, $KeuzesGebruiker, 1)
    if ($AntwoordGebruiker -eq 0) {
        & $ExtraGebruiker
    }
}
##


#Voert ScriptBlock $ExtraGebruiker uit als er ja geantwoord is op de vraag boven het ScriptBlock
if ($AntwoordGebruiker -eq 0) {
    & $ExtraGebruiker
}
#

#Vraagt naar nieuwe pc naam
$NewName = Read-Host -Prompt "Wat is de naam van de PC?(bijv. WS01 of LT01)"
Rename-Computer -NewName "$NewName"
#

## TeamViewer + Ninite installatie
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
$KopTeamViewer = 'TeamViewer'
$VraagTeamViewer = 'Is TeamViewer Correct Geinstalleerd?'
$KeuzesTeamViewer = '&Nee', '&Ja'
$AntwoordTeamViewer = $Host.UI.PromptForChoice($KopTeamViewer, $VraagTeamViewer, $KeuzesTeamViewer, 1)
if ($AntwoordTeamViewer -eq 0) {
    Taskkill /F /IM TeamViewer.exe
    start "C:\Program Files (x86)\TeamViewer\uninstall.exe" /S 
    wget https://trivision.nl/downloads/TeamViewer_Host_Setup.exe -OutFile "C:\TeamViewer.exe"
    start /wait TeamViewer_Host_Setup.exe /norestart
}
##

##Verwijdert HP Bloatware
# Bron https://gist.github.com/mark05e/a79221b4245962a477a49eb281d97388
# List of built-in apps to remove
$UninstallPackages = @(
    "AD2F1837.HPJumpStarts"
    "AD2F1837.HPPCHardwareDiagnosticsWindows"
    "AD2F1837.HPPowerManager"
    "AD2F1837.HPPrivacySettings"
    "AD2F1837.HPSupportAssistant"
    "AD2F1837.HPSureShieldAI"
    "AD2F1837.HPSystemInformation"
    "AD2F1837.HPQuickDrop"
    "AD2F1837.HPWorkWell"
    "AD2F1837.myHP"
    "AD2F1837.HPDesktopSupportUtilities"
    "AD2F1837.HPQuickTouch"
    "AD2F1837.HPEasyClean"
    "AD2F1837.HPSystemInformation"
)

# List of programs to uninstall
$UninstallPrograms = @(
    "HP Client Security Manager"
    "HP Connection Optimizer"
    "HP Documentation"
    "HP MAC Address Manager"
    "HP Notifications"
    "HP Security Update Service"
    "HP System Default Settings"
    "HP Sure Click"
    "HP Sure Click Security Browser"
    "HP Sure Run"
    "HP Sure Recover"
    "HP Sure Sense"
    "HP Sure Sense Installer"
    "HP Wolf Security"
    "HP Wolf Security Application Support for Sure Sense"
    "HP Wolf Security Application Support for Windows"
)

$HPidentifier = "AD2F1837"

$InstalledPackages = Get-AppxPackage -AllUsers `
| Where-Object { ($UninstallPackages -contains $_.Name) -or ($_.Name -match "^$HPidentifier") }

$ProvisionedPackages = Get-AppxProvisionedPackage -Online `
| Where-Object { ($UninstallPackages -contains $_.DisplayName) -or ($_.DisplayName -match "^$HPidentifier") }

$InstalledPrograms = Get-Package | Where-Object { $UninstallPrograms -contains $_.Name }

# Remove appx provisioned packages - AppxProvisionedPackage
ForEach ($ProvPackage in $ProvisionedPackages) {

    Write-Host -Object "$Null"

    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host -Object "$Null"
    }
    Catch { Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]" }
}

# Remove appx packages - AppxPackage
ForEach ($AppxPackage in $InstalledPackages) {
                                            
    Write-Host -Object "$Null"

    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host -Object "$Null"
    }
    Catch { Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]" }
}

# Remove installed programs
$InstalledPrograms | ForEach-Object {

    Write-Host -Object "$Null"

    Try {
        $Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-Host -Object "$Null"
    }
    Catch { Write-Warning -Message "Failed to uninstall: [$($_.Name)]" }
}

# Fallback attempt 1 to remove HP Wolf Security using msiexec
Try {
    MsiExec /x "{0E2E04B0-9EDD-11EB-B38C-10604B96B11E}" /qn /norestart
    Write-Host -Object "$Null"
}
Catch {
    Write-Warning -Object "Failed to uninstall HP Wolf Security using MSI - Error message: $($_.Exception.Message)"
}

# Fallback attempt 2 to remove HP Wolf Security using msiexec
Try {
    MsiExec /x "{4DA839F0-72CF-11EC-B247-3863BB3CB5A8}" /qn /norestart
    Write-Host -Object "$Null"
}
Catch {
    Write-Warning -Object  "Failed to uninstall HP Wolf Security 2 using MSI - Error message: $($_.Exception.Message)"
}
##

#Schakelt BitLocker in op de C schijf als dit niet ingeschakeld is
if (((Get-BitLockerVolume | Where-Object -Property MountPoint -Contains C:).ProtectionStatus) -eq 'Off') {
    Enable-BitLocker -MountPoint "C:" -RecoveryPasswordProtector
}
#

## Specs + BitLocker naar CSV Script
#Slaat specs en bitlocker op als variabele
$Model = (Get-CimInstance Win32_ComputerSystem).Model
$CPU = (Get-CimInstance Win32_Processor -Property Name).Name
$SerieNummer = (Get-CimInstance Win32_BIOS).SerialNumber
$SchijfNaam = (Get-CimInstance Win32_DiskDrive | Where-Object -Property DeviceID -Contains \\.\PHYSICALDRIVE0).Caption
$SchijfGrootte = [math]::Round((Get-CimInstance Win32_DiskDrive -Filter 'DeviceID="\\\\.\\PHYSICALDRIVE0"').Size / 1GB)
$TotaalGeheugen = Write-Output ([math]::Round((Get-CimInstance -Class CIM_PhysicalMemory -ErrorAction Stop | Measure-Object Capacity -Sum).Sum / 1GB)) "GB"
$DimmType1 = (Get-CimInstance -Class CIM_PhysicalMemory).SMBIOSMemoryType | Select-Object -First 1
$DimmType2 = (Get-CimInstance -Class CIM_PhysicalMemory).SMBIOSMemoryType | Select-Object -Skip 1
$BitLockerID = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object RecoveryPassword | Select-Object -ExpandProperty KeyProtectorId
$BitLockerSleutel = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object RecoveryPassword | Select-Object -ExpandProperty RecoveryPassword
#
#Output niks na $TotaalGeheugen in $Specs als er 2 verschillende ramtype's in 1 systeem zitten
if ($DimmType1 -eq $DimmType2) {
    $GeheugenMHZ = Write-Output "@"(Get-CimInstance -Class CIM_PhysicalMemory -ErrorAction Stop | Measure-Object Speed -Minimum).Minimum "MHZ"
}
elseif (-not $DimmType2) {
    $GeheugenMHZ = Write-Output "@"(Get-CimInstance -Class CIM_PhysicalMemory -ErrorAction Stop | Measure-Object Speed -Minimum).Minimum "MHZ"
}
else {
    $GeheugenMHZ = $null
}
#
#Output bitlocker id, bitlocker key, PC model, CPU, serienummer, RAM info en drive info naar een csv bestand
$Specs = [PSCustomObject]@{
    Model                       = "$Model"
    CPU                         = "$CPU"
    SerieNummer                 = "$SerieNummer"
    SchijfInfo                  = "$SchijfGrootte GiB $SchijfNaam"
    RAMInfo                     = "$TotaalGeheugen $GeheugenMHZ"
    "Bitlocker ID"              = "$BitlockerID"
    "Bitlocker Herstel Sleutel" = "$BitLockerSleutel"
}
$specs | Export-Csv H:\PcInfo$NewName.csv -NoTypeInformation
#
##

##Corrigeert tijd en tijdzone, en voegt tijdservers toe
#Synct de tijd en voegt tijdservers toe
Start-Service w32time
w32tm /register
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
w32tm /resync /force
Write-Host "De tijd en datum zijn nu goed gezet."
#Verandert tijdzone
tzutil /s "W. Europe Standard Time"
##

#Verwijdert Windows.old als het bestaat
if ((Test-Path -Path 'C:\Windows.old' -PathType Container) -eq $true) {
    TAKEOWN /f C:\Windows.old\*.*
    ICACLS C:\Windows.old\*.* /Grant 'System:(F)'
    Remove-Item C:\Windows.old\*.*
}
#

#Zet UAC uit via registry
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
#

#Schakelt updates voor andere microsoft producten in
$ServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
$ServiceManager.ClientApplicationID = "My App"
$ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "") 
#

#Voert ScriptBlock $WindowsUpdate uit
& $WindowsUpdate
#

#Voert ScriptBlock $Office365 uit als er ja geantwoord is op de vraag onder het ScriptBlock
if ($AntwoordOffice -eq 0) {
    & $Office365
}
#

#Verwijdert alle ps1, xml en exe bestanden en herstart de computer 
Get-ChildItem H:\ -Include *.ps1, *.xml, *.exe -Recurse | Remove-Item -Recurse
Set-ExecutionPolicy Restricted
Restart-Computer
#