# Trivision-PC-Script
PC installatie script voor trivision


Dit script gaat ervan uit dat je ingelogd bent als TriAdmin, dat het uitgevoerd word als administrator en dat je internettoegang hebt.


Om te gebruiken zet bestanden op root van usb en start het script als admin


Werkt op windows 10 en 11.

Werkt mogelijk ook op windows server 2019 en 2022 maar dit is niet getest.

De huidige versie van het scipt kan het volgende:

- Tijdzone, datum en tijd goed zetten(met als tijdzone Europe/Amsterdam)
- pc naam aanpassen
- UAC uitzetten
- evt een extra gebruiker aanmaken en die aan de Administrators groep toevoegen
- Updates van andere microsoft producten binnenhalen met windows updates
- Bitlocker instellen en ID + sleutel naar tekst bestand zetten op usb
- Windows.Old map verwijderen als die bestaat
- Alle updates installeren
- Java, chrome, foxit en 7-zip installeren
- Trivision versie van teamviewer installeren


To Do:
- (HOGE PRIORITEIT) Zorgen dat er maar 1 keer gevragen hoeft te worden naar de schijf letter
- (HOGE PRIORITEIT) Groot gedeelte van cmd script overzetten naar powershell
- (dit gebeurt pas na release 1.0)(HOGE PRIORITEIT) Foto + tekst instructie maken
- (HOGE PRIORITEIT) script laten downloaden van github zodat dit niet elke nieuwe release handmatig hoeft te gebeuren
- ja/nee vragen vervangen met prompts ipv handmatig in moeten voeren
- Kijken of office en tom semi-automatisch geinstalleerd kunnen worden vanuit powershell
- Kijken naar mogelijkheid teamviewer updaten via powershell
- Mogelijk bitlocker opzetten via powershell en gegevens exporteren naar text bestand op usb
- User input verminderen
- Kijken naar mogelijkheid voor silent install van teamviewer en ninite
- Zoeken naar applicatie om specifieke hardware info te exporteren naar een text bestand via powershell
- (LAGE PRIORITEIT) Testen op windows server 2019 en windows server 2022
