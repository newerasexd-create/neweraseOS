$ErrorActionPreference = "Stop"

$gitOut = "protocol=https`nhost=github.com" | & "C:\Program Files\Git\cmd\git.exe" credential fill
$token = ($gitOut | Select-String "password=").ToString().Replace("password=","").Trim()
$headers = @{"Authorization"="Bearer $token"; "User-Agent"="PowerShell"; "Accept"="application/vnd.github+json"}
$runId = "39957070446"
$targetDir = "F:\obraz"

Write-Host "Waiting for build $runId to complete..."
while ($true) {
    Start-Sleep -Seconds 20
    $run = Invoke-RestMethod -Uri "https://api.github.com/repos/newerasexd-create/neweraseOS/actions/runs/$runId" -Headers $headers
    Write-Host "Status: $($run.status)..."
    if ($run.status -eq "completed") {
        Write-Host "Build finished with conclusion: $($run.conclusion)"
        if ($run.conclusion -ne "success") {
            Write-Host "Build failed!"
            exit 1
        }
        break
    }
}

Write-Host "Fetching artifact..."
$artifacts = Invoke-RestMethod -Uri "https://api.github.com/repos/newerasexd-create/neweraseOS/actions/runs/$runId/artifacts" -Headers $headers
$artId = $artifacts.artifacts[0].id

$req = [System.Net.HttpWebRequest]::Create("https://api.github.com/repos/newerasexd-create/neweraseOS/actions/artifacts/$artId/zip")
$req.Headers.Add("Authorization", "Bearer $token")
$req.UserAgent = "PowerShell"
$req.AllowAutoRedirect = $false

$resp = $req.GetResponse()
$redirectUrl = $resp.GetResponseHeader("Location")
$resp.Close()

$zipPath = "$targetDir\neweraseOS-final.zip"
Write-Host "Downloading to $zipPath..."
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($redirectUrl, $zipPath)

Write-Host "Extracting to $targetDir..."
Expand-Archive -Path $zipPath -DestinationPath "$targetDir\extracted" -Force
$isoFile = (Get-ChildItem -Path "$targetDir\extracted" -Filter "*.iso")[0].FullName
Copy-Item $isoFile "$targetDir\neweraseOS.iso" -Force

Write-Host "Configuring VirtualBox VM 'newerase'..."
$vbox = "F:\virtual\VBoxManage.exe"
& $vbox modifyvm "newerase" --ostype "ArchLinux_64" --firmware "efi" --long-mode on --pae on --vram 128 --graphicscontroller "vboxsvga" --accelerate-3d off
& $vbox storageattach "newerase" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$targetDir\neweraseOS.iso"

Write-Host "[SUCCESS] neweraseOS.iso is ready in F:\obraz and attached to VirtualBox VM!"
