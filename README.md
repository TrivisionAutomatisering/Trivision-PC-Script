# Trivision-PC-Script
PC installatie script voor trivision


Dit script gaat ervan uit dat je ingelogd bent als TriAdmin, dat het uitgevoerd word als administrator en dat je internettoegang hebt.

Om te gebruiken zet bestanden op root van usb en start semi automated install script

Werkt op windows 10 en 11.

Werkt mogelijk ook op windows server 2019 en 2022 maar dit is niet getest.

De huidige versie van het scipt kan het volgende:

- Tijdzone, datum en tijd goed zetten(met als tijdzone Europe/Amsterdam)
- pc naam aanpassen
- UAC uitzetten
- evt een extra gebruiker aanmaken en die aan de Administrators groep toevoegen
- Windows update notificaties aanzetten
- Windows.Old map verwijderen als die bestaat
- Alle updates installeren
- Java, chrome, foxit en 7-zip installeren
- Trivision versie van teamviewer installeren


To Do:
- (HOGE PRIORITEIT) Zorgen dat er maar 1 keer gevragen hoeft te worden naar de schijf letter
- (HOGE PRIORITEIT) Groot gedeelte van cmd script overzetten naar powershell
- testen op windows server 2019 en windows server 2022
- Kijken of office en tom semi-automatisch geinstalleerd kunnen worden vanuit powershell
- Kijken naar mogelijkheid teamviewer updaten via powershell
- Mogelijk bitlocker opzetten via powershell
- User input verminderen
- Kijken naar mogelijkheid voor silent install van teamviewer en ninite
- Zoeken naar applicatie om specifieke hardware info te exporteren naar een text bestand via powershell
- (LAGE PRIORITEIT) foto + tekst instructie maken
