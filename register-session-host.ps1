# ==========================
# Parameters
# ==========================
param(
    [Parameter(Mandatory=$true)]
    [string]$RegistrationToken,
    
    [Parameter(Mandatory=$false)]
    [string]$DownloadPath = "C:\Temp"
)

# ==========================
# Create working directory
# ==========================
New-Item -ItemType Directory -Path $DownloadPath -Force | Out-Null
Set-Location $DownloadPath

# ==========================
# URLs (Microsoft official)
# ==========================
$AgentUrl = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv"
$BootLoaderUrl = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH"

$AgentMsi = "AVDAgent.msi"
$BootLoaderMsi = "AVDBootLoader.msi"

# ==========================
# Download AVD Agent
# ==========================
Invoke-WebRequest -Uri $AgentUrl -OutFile $AgentMsi -UseBasicParsing

# ==========================
# Download AVD Boot Loader
# ==========================
Invoke-WebRequest -Uri $BootLoaderUrl -OutFile $BootLoaderMsi -UseBasicParsing

# ==========================
# Install AVD Agent
# ==========================
Start-Process msiexec.exe -ArgumentList "/i `"$AgentMsi`" /quiet /norestart REGISTRATIONTOKEN=$RegistrationToken" -Wait

# ==========================
# Install AVD Boot Loader
# ==========================
Start-Process msiexec.exe -ArgumentList "/i `"$BootLoaderMsi`" /quiet /norestart" -Wait

# ==========================
# Final reboot
# ==========================
Restart-Computer -Force