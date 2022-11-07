$UserName = Read-Host -Prompt "Wat is de gebruikersnaam?"
$UserPswd = Read-Host -Prompt "Wat is het wachtwoord?"
$UserFullName = Read-Host -Prompt "Wat is de volledige naam?"
$secureString = ConvertTo-SecureString $UserPswd -asplaintext -Force
New-LocalUser -Name "$UserName" -Password $secureString -FullName "$UserFullName"
Add-LocalGroupMember -Group "Administrators" -Member "$UserName"
$Kop = 'Extra Gebruiker'
$Vraag = 'Wil je nog een gebruiker toevoegen?'
$Keuzes = '&Ja', '&Nee'
$Antwoord = $Host.UI.PromptForChoice($Kop, $Vraag, $Keuzes, 1)
if ($Antwoord -eq 0) {
    powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\ExtraGebruikers.ps1
} else {
    Get-ChildItem H:\* -Include *.ps1,*.xml,*.exe -Recurse | Remove-Item -Recurse
    Get-ChildItem H:\* -Attributes Directory -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse 
    Restart-Computer
}
