$UserName = Read-Host -Prompt "Wat is de gebruikersnaam?"
$UserPswd = Read-Host -Prompt "Wat is het wachtwoord?"
$UserFullName = Read-Host -Prompt "Wat is de volledige naam?"
$secureString = ConvertTo-SecureString $UserPswd -asplaintext -Force
New-LocalUser -Name "$UserName" -Password $secureString -FullName "$UserFullName"
Add-LocalGroupMember -Group "Administrators" -Member "$UserName"
$ExtraUsers= Read-Host -Prompt "Wil je nog extra gebruikers toevoegen?(ja/nee)"
if ($ExtraUsers -eq 'ja') {
    powershell -ExecutionPolicy Bypass -File H:\Resources\ExtraGebruikers.ps1
    }
elseif ($ExtraUsers -eq 'nee') {
     echo "Het systeem gaat nu opnieuw opstarten."
     Start-Sleep -Seconds 3
     Restart-Computer
}
else {
      echo "Dat is een fout antwoord, het script sluit nu."
      Start-Sleep -Seconds 3
      Exit-PSHostProcess
}
