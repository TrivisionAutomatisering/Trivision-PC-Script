set /p PCName="Wat is de naam van de PC?(bijv. WS01 of LT01)"
echo %PCName%
tzutil /s "W. Europe Standard Time"
echo "De tijdzone is nu goed gezet"
wmic computersystem where name="%computername%" call rename name="%PCName%"
%ScriptDrive%\Resources\Ninite.exe
echo "Ninite is geïnstalleerd"
reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
echo "UAC is uitgezet"
takeown /F c:\Windows.old\* /R /A /D Y
cacls c:\Windows.old\*.* /T /grant administrators:F
rmdir /S /Q c:\Windows.old
echo "Windows.old is verwijderd als deze er was"
