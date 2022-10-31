$Kop2 = 'Office taal'
$Vraag2 = 'In welke taal moet office geinstalleerd worden?'
$Keuzes2 = '&nl-NL', '&en-US'
$Antwoord2 = $Host.UI.PromptForChoice($Kop2, $Vraag2, $Keuzes2, 1)
if ($Antwoord2 -eq 0) {
    H:/Resources/Office365/setup.exe /configure "Office nl-NL x64.xml"
} elseif ($Antwoord2 -eq 1) {
          H:\Resources\Office365\setup.exe /configure "Office en-US x64.xml"
}
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
