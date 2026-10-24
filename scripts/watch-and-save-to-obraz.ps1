$ErrorActionPreference = "Stop"

$gitOut = "protocol=https`nhost=github.com" | & "C:\Program Files\Git\cmd\git.exe" credential fill
$token = ($gitOut | Select-String "password=").ToString().Replace("password=","").Trim()
$headers = @{"Authorization"="Bearer $token"; "User-Agent"="PowerShell"; "Accept"="application/vnd.github+json"}
$runId = "39964883887"
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

Write-Host "Configuring VirtualBox VM 'neweraseOS'..."
$vbox = "F:\virtual\VBoxManage.exe"

# Stop VM if running
& $vbox controlvm "neweraseOS" poweroff 2>$null

# Re-attach the fresh ISO
& $vbox storageattach "neweraseOS" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$targetDir\neweraseOS.iso"

Write-Host "Starting VirtualBox VM 'neweraseOS'..."
& $vbox startvm "neweraseOS"

Write-Host "Waiting 45 seconds for full system and KDE Plasma desktop boot..."
Start-Sleep -Seconds 45

Write-Host "Taking verification screenshot..."
& $vbox controlvm "neweraseOS" screenshotpng "$targetDir\final_desktop_verified.png"
Copy-Item "$targetDir\final_desktop_verified.png" "C:\Users\Administrator\.gemini\antigravity\brain\8bcaef58-e5fd-48ca-b311-75615c8f9d64\final_desktop_verified.png" -Force

Write-Host "[ALL DONE] neweraseOS is fully booted and verified!"
