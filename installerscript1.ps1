# Verifica se l'utente ha i privilegi di amministratore, altrimenti richiedi i permessi di amministratore
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -Verb RunAs
	Exit
}

# Verifica la versione di Windows
if ([System.Environment]::OSVersion.Version.Build -lt 18363) {
	Write-Host "ATTENZIONE: Per usare lo script è necessario aggiornare almeno a Windows 10/11 ..." -ForegroundColor Red
	Start-Sleep -Seconds 5
	Exit
}

Write-Output "Installazione programmi automatizzata"

$wc = New-Object System.Net.WebClient

$output = ".\DesktopAppInstaller.exe"
$output2 = ".\VCLibs.exe"

# Scarica l'ultima versione di NuGet
$json = Invoke-WebRequest 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -UseBasicParsing
$psobj = ConvertFrom-Json $json.Content
$version = $psobj.tag_name

Write-Host "Download di NuGet in corso..." -ForegroundColor White -BackgroundColor Green
$wc.DownloadFile("https://dist.nuget.org/win-x86-commandline/$version/nuget.exe", $output)
Write-Host "Download di VCLibs in corso..." -ForegroundColor White -BackgroundColor Green
if ([Environment]::Is64BitOperatingSystem) {
	$wc.DownloadFile("https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx", $output2)
} else {
	$wc.DownloadFile("https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx", $output2)
}
Clear-Host

# Installa VCLibs
Add-AppxPackage -Path $output2 -ErrorAction SilentlyContinue

# Installa i programmi desiderati con NuGet
nuget install Evernote -Source https://api.nuget.org/v3/index.json -OutputDirectory .\Packages -Verbosity detailed -NonInteractive -PackageSaveMode nupkg -AcceptLicense -ForceEnglishOutput
nuget install AIMP -Source https://api.nuget.org/v3/index.json -OutputDirectory .\Packages -Verbosity detailed -NonInteractive -PackageSaveMode nupkg -AcceptLicense -ForceEnglishOutput

