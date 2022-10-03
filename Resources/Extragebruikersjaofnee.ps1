$ScriptDrive= Read-Host -Prompt "Wat is de schijf letter van deze usb?(bijv X:)"
$ExtraUsers= Read-Host -Prompt "Wil je nog een gebruiker toevoegen?(ja/nee)"
if ($ExtraUsers -eq 'ja') {
     powershell -ExecutionPolicy Bypass -File $ScriptDrive\Resources\ExtraGebruikers.ps1
     }
elseif ($ExtraUsers -eq "nee") {
     echo "Het systeem gaat nu opnieuw opstarten."
     Start-Sleep -Seconds 3
     Restart-Computer
}
else {
      echo "Dat is een fout antwoord, probeer het opnieuw."
      Start-Sleep -Seconds 3
      powershell -ExecutionPolicy Bypass -File $ScriptDrive\Resources\Extragebruikersjaofnee.ps1
}