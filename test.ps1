#Sites voor powershell hulp:
#ChatGPT(neem info met een korrel zout): chat.openai.com
#Microsoft: https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-5.1
#Discord PowerShell groep: https://discord.com/invite/powershell
#En natuurlijk: google.com

#Neemt variabele over vanuit het cmd start script
param ([string]$ScriptDrive)
#
#Requires -RunAsAdministrator

#Verandert usb schijf letter naar H:
Get-Partition -DriveLetter $ScriptDrive | Set-Partition -NewDriveLetter H
#

#Checkt of de folder H:\Temp bestaat, zo niet dan word deze aangemaakt
if((Test-Path H:\Temp) -eq $False){
    New-Item -path H:\ -Name "Temp" -ItemType "directory"
}

## Windows Update Script
# Failure counter voor Windows Update
$UpdateFailCounter = 0
#Windows Update ScriptBlock LET OP: Dit is een stuk script wat later pas opgeroepen wordt.
$WindowsUpdate = {
# Indien de update faalt word het opnieuw geprobeerd. Elke keer dat het opnieuw geprobeerd word gaat $UpdateFailCounter met 1 omhoog, vanaf dat $UpdateFailCounter op 3 staat word er elke poging gevragen of je het nog een keer wilt proberen.  
try{
#Download en installeert alle windows updates 2 keer maar bij de 2e keer worden updates die een reboot nodig hebben overgeslagen omdat deze anders dubbel gedownload worden
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot -ignoreRebootRequired
}catch{
$UpdateFailCounter = $UpdateFailCounter + 1
if($UpdateFailCounter -gt 3){
#Geeft keuze of je nog een keer windows update wilt proberen.
$KopWindowsUpdate = 'Windows Update'
$VraagWindowsUpdate = 'Er was al 3 keer een fout tijdens het updaten, wil je het opnieuw proberen?'
$KeuzesWindowsUpdate = '&Ja', '&Nee'
$AntwoordWindowsUpdate = $Host.UI.PromptForChoice($KopWindowsUpdate, $VraagWindowsUpdate, $KeuzesWindowsUpdate, 1)
#Als het antwoord ja is, dan word het scriptblok $WindowsUpdate gedraait. 
if($AntwoordWindowsUpdate -eq 0){
    & $WindowsUpdate
}
} 
#Als $UpdateFailCounter 3 of lager is word het scriptblock $WindowsUpdate uitgevoerd 
else{
    Write-Warning -Message "Er was een fout Het word nu opnieuw geprobeerd(dit is geen loop)"
    & $WindowsUpdate
}
}
}
##

##Office Script
#Office ScriptBlock installeert office met dezelfde taal als de OS LET OP: dit is een stuk script wat later pas opgeroepen word net zoals $WindowsUpdate
$Office365 = {
    #Download Office365.zip van de laatste github release
    Invoke-WebRequest -Uri https://github.com/TrivisionAutomatisering/Trivision-PC-Script/releases/latest/download/Office365.zip -OutFile H:\Temp\Office365.zip
    #Pakt de zip uit in H:\Temp
    Expand-Archive H:\Temp\Office365.zip -DestinationPath H:\Temp -Force
    #Start office installatie
    Start-Process "H:\Temp\setup.exe" -ArgumentList '/configure "H:\Temp\Office nl-NL x64.xml"'
    }
#Vraagt of office geinstalleerd moet worden
$KopOffice = 'Office 365'
$VraagOffice = 'Wil je Office 365 installeren?'
$KeuzesOffice = '&Ja', '&Nee'
$AntwoordOffice = $Host.UI.PromptForChoice($KopOffice, $VraagOffice, $KeuzesOffice, 1)
##

##Extra Gebruiker Script
#ScriptBlock dat vraagt naar gegevens voor de gebruiker, de gebruiker aanmaakt, toevoegt aan admin en dan vraagt of er nog een gebruiker toegevoegd moet worden.
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


#Voert scriptblok $ExtraGebruiker uit als er ja geantwoord is op de vraag boven het ScriptBlock
if ($AntwoordGebruiker -eq 0) {
    & $ExtraGebruiker
}
#

#Checkt of er een bestand is genaamd geenbitlocker.txt
if ((Test-Path H:\geenbitlocker.txt) -eq $False) {
    #Schakelt BitLocker in op de C schijf als dit niet ingeschakeld is
    if (((Get-BitLockerVolume | Where-Object -Property MountPoint -Contains C:).ProtectionStatus) -eq 'Off') {
        Enable-BitLocker -MountPoint "C:" -RecoveryPasswordProtector
        manage-bde -protectors -add "C:" -tpm
        manage-bde -protectors -enable "C:"
    } else{
        Write-Host Bitlocker was al ingesteld
    }
}
#

#Vraagt naar nieuwe pc naam
$NewName = Read-Host -Prompt "Wat is de naam van de PC?(bijv. WS01 of LT01)"
#Verandert pc naam naar antwoord op $NewName
Rename-Computer -NewName "$NewName"
#

## TeamViewer installatie
$KopTeamViewer = 'TeamViewer'
$VraagTeamViewer = 'Wil je TeamViewer installeren?'
$KeuzesTeamViewer = '&Nee', '&Host', '&QS'
$AntwoordTeamviewer = $Host.UI.PromptForChoice($KopTeamViewer, $VraagTeamViewer, $KeuzesTeamViewer, 1)
if($AntwoordTeamviewer -eq 1){
#Download TeamViewer Host
Invoke-WebRequest https://trivision.nl/downloads/TeamViewer_Host_Setup.exe -OutFile "H:\Temp\TeamViewer.exe"
#Voert TeamViewer uit en wacht totdat de setup gesloten is
    Start-Process "H:\Temp\TeamViewer.exe" -Wait
} elseif($AntwoordTeamviewer -eq 2){
    #Maakt folder "C:/Trivision Support" aan
    New-Item -Path "C:/Trivision Support" -ItemType Directory
    #Download Teamviewer QuickSupport
    Invoke-WebRequest https://trivision.nl/downloads/TeamViewerQS.exe -OutFile "C:/Trivision Support/TeamViewerQS.exe"
    #Opent folder "C:/Trivision Support"
    Invoke-Item "C:/Trivision Support"
    #Maakt snelkoppeling op bureaublad
    $ComObj = New-Object -ComObject WScript.Shell
    $ShortCut = $ComObj.CreateShortcut(([Environment]::GetFolderPath('CommonDesktopDirectory'))) + "\TeamViewerQS.lnk")
    $ShortCut.TargetPath = "C:/Trivision Support/TeamViewerQS.exe"
    $ShortCut.Description = "TeamViewer Quick Support - Trivision"
    $ShortCut.WindowStyle = 1
    $ShortCut.Save()
}

#Herinstalleert teamviewer als de installatie gefaald is
$TeamViewerHostHerinstallatie = {
$KopTeamViewer2 = 'TeamViewer'
$VraagTeamViewer2 = 'Is TeamViewer Correct Geinstalleerd?'
$KeuzesTeamViewer2 = '&Nee', '&Ja'
$AntwoordTeamViewer2 = $Host.UI.PromptForChoice($KopTeamViewer2, $VraagTeamViewer2, $KeuzesTeamViewer2, 1)
if ($AntwoordTeamViewer2 -eq 0) {
    #Sluit Teamviewer
    Taskkill /F /IM TeamViewer.exe
    #Start teamviewer uninstaller
    Start-Process "C:\Program Files (x86)\TeamViewer\uninstall.exe" /S
    #Download TeamViewer host opnieuw 
    Invoke-WebRequest https://trivision.nl/downloads/TeamViewer_Host_Setup.exe -OutFile "H:\Temp\TeamViewer.exe"
    Start-Process "H:\Temp\TeamViewer.exe" -Wait
}
}
if($AntwoordTeamviewer -eq 1){
    #Start ScriptBlock $TeamViewerHostHerinstallatie
    & $TeamViewerHostHerinstallatie
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

#installeert chocolatey | https://chocolatey.org/
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#Installeert 7zip, foxit, chrome en java
Start-Process -NoNewWindow -Wait -FilePath "choco" -ArgumentList "install 7zip --yes"
Start-Process -NoNewWindow -Wait -FilePath "choco" -ArgumentList "install foxitreader --yes"
Start-Process -NoNewWindow -Wait -FilePath "choco" -ArgumentList "install googlechrome --yes"
Start-Process -NoNewWindow -Wait -FilePath "choco" -ArgumentList "install javaruntime --yes"
Start-Process -NoNewWindow -Wait -FilePath "choco" -ArgumentList "install pswindowsupdate --yes"

## Specs + BitLocker naar CSV Script
#Checkt ram type en zet variabele hiervoor
$SMBiosMemoryType = ((Get-CimInstance -Class CIM_PhysicalMemory).SMBIOSMemoryType | Select-Object -First 1)
if($SMBiosMemoryType -in 26,94,165){
    $MemoryType = "DDR4"
} elseif($SMBiosMemoryType -eq 30){
    $MemoryType = "LPDDR4"
} elseif($SMBiosMemoryType -eq 34){
    $MemoryType = "DDR5"
} elseif($SMBiosMemoryType -eq 35){
    $MemoryType = "LPDDR5"
} elseif($SMBiosMemoryType -in 24,58,42){
    $MemoryType = "DDR3"
} elseif($SMBiosMemoryType -eq 29){
    $MemoryType = "LPDDR3"
} else{
    $SMBiosMemoryType = $Null
}

#Bepaalt op welke manier het model opgehaald word aangezien hp dit anders doet als de rest
if((Get-CimInstance Win32_ComputerSystem).Manufacturer -eq "HP" -or (Get-CimInstance Win32_ComputerSystem).Manufacturer -eq "Hewlett Packard"){
$Model = (Get-CimInstance Win32_ComputerSystem).Model
} else{
    $Model = (Get-CimInstance Win32_ComputerSystem).SystemFamily
}
#Slaat specs en bitlocker gegevens op als variabele
$CPU = (Get-CimInstance Win32_Processor -Property Name).Name
$SerieNummer = (Get-CimInstance Win32_BIOS).SerialNumber
$SchijfNaam = (Get-CimInstance Win32_DiskDrive | Where-Object -Property DeviceID -Contains \\.\PHYSICALDRIVE0).Caption
$SchijfGrootte = [math]::Round((Get-CimInstance Win32_DiskDrive -Filter 'DeviceID="\\\\.\\PHYSICALDRIVE0"').Size / 1GB)
$TotaalGeheugen = Write-Output ([math]::Round((Get-CimInstance -Class CIM_PhysicalMemory -ErrorAction Stop | Measure-Object Capacity -Sum).Sum / 1GB)) "GB"
$GeheugenMHZ = Write-Output "@"(Get-CimInstance -Class CIM_PhysicalMemory -ErrorAction Stop | Measure-Object Speed -Minimum).Minimum "MHZ"
$BitLockerID = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object RecoveryPassword | Select-Object -ExpandProperty KeyProtectorId
$BitLockerSleutel = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object RecoveryPassword | Select-Object -ExpandProperty RecoveryPassword
#
#Output bitlocker id, bitlocker key, PC model, CPU, serienummer, RAM info en drive info naar een csv bestand
#https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-5.1
$Specs = [PSCustomObject]@{
    Model              = "$Model"
    SerieNummer        = "$SerieNummer"
    CPU                = "$CPU"
    SchijfInfo         = "$SchijfGrootte GiB $SchijfNaam"
    RAMInfo            = "$MemoryType $TotaalGeheugen $GeheugenMHZ"
    PCNaam             = "$NewName"
    "ID:"              = "$BitlockerID" -replace('[{}]') #het -replace zorgt ervoor dat de brackets bij de id weggehaald worden
    "Herstel Sleutel:" = "$BitLockerSleutel"
}
$Specs | Export-Csv H:\PcInfo$NewName.csv -NoTypeInformation
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

#Checkt of Windows.old bestaat
if ((Test-Path -Path 'C:\Windows.old' -PathType Container) -eq $true) {
    #Maakt huidige gebruiker eigenaar van de folder
    TAKEOWN /f C:\Windows.old\*.*
    ICACLS C:\Windows.old\*.* /Grant 'System:(F)'
    #Verwijdert Windows.old
    Remove-Item C:\Windows.old\*.*
}

#Zet UAC uit via registry
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
#

#Schakelt updates voor andere microsoft producten in
$ServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
$ServiceManager.ClientApplicationID = "My App"
$ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "") 
#

Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'RestartNotificationsAllowed2' -Value 1 -Type DWord -Force

#Voert ScriptBlock $Office365 uit als er ja geantwoord is op de vraag onder het ScriptBlock
if ($AntwoordOffice -eq 0) {
    & $Office365
}
#

#Voert ScriptBlock $WindowsUpdate uit
& $WindowsUpdate
#

#Download .bat bestand om script te starten
Invoke-WebRequest -Uri "https://github.com/TrivisionAutomatisering/Trivision-PC-Script/releases/latest/download/Start.script.als.admin.bat" -OutFile "H:\Start.script.als.admin.bat"

#Maakt taak aan om windows update te draaien bij inloggen en verwijdert taak als hij klaar is met updaten
$taskName = "WindowsUpdateOnStartup"
$taskAction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-ExecutionPolicy Bypass -Command ((Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot), (Unregister-ScheduledTask -TaskName "WindowsUpdateOnStartup" -Confirm:$false))'
$taskTrigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -RunLevel Highest

#Verwijdert Temp folder op usb en het test.ps1 bestand en herstart de computer
Remove-Item "H:\test.ps1"
Remove-Item "H:\Temp" -Recurse
Restart-Computer
