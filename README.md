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
- (dit gebeurt pas na release 1.0)(HOGE PRIORITEIT) Foto + tekst instructie maken
- TeamViewer herinstallatie prompt toevoegen
- mogelijk dymon integreren dmv https://github.com/minlux/dymon
- HP Bloatware verwijderen dmv https://gist.github.com/mark05e/a79221b4245962a477a49eb281d97388
