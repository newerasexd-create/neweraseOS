$ErrorActionPreference = "Stop"

$vbox = "F:\virtual\VBoxManage.exe"
$vmName = "neweraseOS"
$isoPath = "F:\obraz\neweraseOS.iso"
$screenshotPath = "C:\Users\Administrator\.gemini\antigravity\brain\8bcaef58-e5fd-48ca-b311-75615c8f9d64\final_desktop_verified.png"

Write-Host "Verifying ISO presence..."
if (!(Test-Path $isoPath)) {
    throw "ISO not found at $isoPath"
}
$isoInfo = Get-Item $isoPath
Write-Host "ISO file size: $($isoInfo.Length) bytes ($([math]::Round($isoInfo.Length/1GB, 2)) GB)"

Write-Host "Checking VM status..."
$vmState = (& $vbox showvminfo $vmName --machinereadable | Select-String 'VMState=').ToString().Split('=')[1].Trim('"')
Write-Host "Current VM State: $vmState"
if ($vmState -eq "running") {
    Write-Host "Stopping running VM..."
    & $vbox controlvm $vmName poweroff
    Start-Sleep -Seconds 2
}

Write-Host "Attaching new ISO..."
& $vbox storageattach $vmName --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium $isoPath

Write-Host "Starting VM '$vmName'..."
& $vbox startvm $vmName

Write-Host "Waiting 50 seconds for full kernel, systemd, SDDM, and Plasma 6 boot..."
Start-Sleep -Seconds 50

Write-Host "Capturing desktop screenshot..."
& $vbox controlvm $vmName screenshotpng $screenshotPath
Write-Host "Screenshot saved to $screenshotPath"
Copy-Item $screenshotPath "F:\obraz\final_desktop_verified.png" -Force

$screenSize = (Get-Item $screenshotPath).Length
Write-Host "Screenshot size: $screenSize bytes"
