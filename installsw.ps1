# Installa Winget se non è già installato
if(!(Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Invoke-WebRequest -Uri "https://aka.ms/winget-64" -OutFile "$env:TEMP\winget-cli.appxbundle"
    Add-AppxPackage "$env:TEMP\winget-cli.appxbundle"
}

# Configura Winget
winget settings --set autoUpgrade=true --set telemetryEnabled=false

# Aggiorna Windows
winget install Microsoft.WindowsAppSDK

# Installa programmi
winget install Microsoft.VisualStudioCode
winget install Google.Chrome
winget install 7zip
winget install Notepad++

# Installa driver
winget install Intel-Chipset-Device-Software
winget install Intel-Network-Adapter-Driver-for-Windows-10

# Installa aggiornamenti Windows
winget install Microsoft.Windows10CumulativeUpdate

# Riavvia il computer per completare l'installazione degli aggiornamenti
Restart-Computer -Force