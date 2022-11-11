H:/Resources/Office365/setup.exe /configure "H:\Resources\office365\Office nl-NL x64.xml"
#gaat naar script om extra gebruikers toe te voegen
$Kop = 'Extra Gebruiker'
$Vraag = 'Wil je een extra gebruiker toevoegen?'
$Keuzes = '&Ja', '&Nee'
$Antwoord = $Host.UI.PromptForChoice($Kop, $Vraag, $Keuzes, 1)
if ($Antwoord -eq 0) {
    powershell.exe -ExecutionPolicy UnRestricted -File H:\Resources\ExtraGebruikers.ps1
} else {
    Restart-Computer
}
