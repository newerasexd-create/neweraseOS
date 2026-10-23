$ErrorActionPreference = "Stop"

$gitOut = "protocol=https`nhost=github.com" | & "C:\Program Files\Git\cmd\git.exe" credential fill
$token = ($gitOut | Select-String "password=").ToString().Replace("password=","").Trim()
$artifactId = "12500013629"

$isoDir = "F:\iso"
if (!(Test-Path $isoDir)) {
    New-Item -ItemType Directory -Path $isoDir -Force | Out-Null
}

$zipPath = "$isoDir\neweraseOS-v6.zip"

Write-Host "[1/4] Getting artifact download URL from GitHub API..."
$req = [System.Net.HttpWebRequest]::Create("https://api.github.com/repos/newerasexd-create/neweraseOS/actions/artifacts/$artifactId/zip")
$req.Headers.Add("Authorization", "Bearer $token")
$req.UserAgent = "PowerShell"
$req.AllowAutoRedirect = $false

$resp = $req.GetResponse()
$redirectUrl = $resp.GetResponseHeader("Location")
$resp.Close()

Write-Host "[2/4] Downloading neweraseOS ISO artifact (~3.6 GB)..."
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($redirectUrl, $zipPath)
Write-Host "Download complete: $([Math]::Round((Get-Item $zipPath).Length / 1GB, 2)) GB"

Write-Host "[3/4] Extracting ISO file..."
Expand-Archive -Path $zipPath -DestinationPath "$isoDir\v6" -Force
$isoFile = (Get-ChildItem -Path "$isoDir\v6" -Filter "*.iso")[0].FullName
Write-Host "ISO extracted to: $isoFile"

Write-Host "[4/4] Applying VM configuration & attaching ISO in VirtualBox..."
$vboxManage = "F:\virtual\VBoxManage.exe"

# Make sure VM is stopped if running
& $vboxManage controlvm "newerase" poweroff 2>$null

# Apply settings
& $vboxManage modifyvm "newerase" --ostype "ArchLinux_64"
& $vboxManage modifyvm "newerase" --firmware "efi"
& $vboxManage modifyvm "newerase" --long-mode on
& $vboxManage modifyvm "newerase" --pae on
& $vboxManage modifyvm "newerase" --vram 128
& $vboxManage modifyvm "newerase" --graphicscontroller "vboxsvga"
& $vboxManage modifyvm "newerase" --accelerate-3d on

# Attach new ISO to IDE optical drive (port 1 device 0)
& $vboxManage storageattach "newerase" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium $isoFile

Write-Host "[SUCCESS] All settings and new ISO applied to VirtualBox VM 'newerase'!"
