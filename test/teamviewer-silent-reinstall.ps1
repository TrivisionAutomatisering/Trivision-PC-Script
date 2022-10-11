Taskkill /F /IM TeamViewer.exe
"C:\Program Files (x86)\TeamViewer\uninstall.exe" /S
wget https://trivision.nl/downloads/TeamViewer_Host_Setup.exe -OutFile "C:\TeamViewer.exe"
start /wait TeamViewer_Host_Setup.exe /S /norestart