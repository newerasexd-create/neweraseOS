$ErrorActionPreference = "Stop"

$gitOut = "protocol=https`nhost=github.com" | & "C:\Program Files\Git\cmd\git.exe" credential fill
$token = ($gitOut | Select-String "password=").ToString().Replace("password=","").Trim()
$runId = "39964883887"

$headers = @{"Authorization"="Bearer $token"; "User-Agent"="PowerShell"; "Accept"="application/vnd.github+json"}
$artifacts = Invoke-RestMethod -Uri "https://api.github.com/repos/newerasexd-create/neweraseOS/actions/runs/$runId/artifacts" -Headers $headers
$artId = $artifacts.artifacts[0].id
Write-Host "Artifact ID: $artId (Size: $($artifacts.artifacts[0].size_in_bytes) bytes)"

$req = [System.Net.HttpWebRequest]::Create("https://api.github.com/repos/newerasexd-create/neweraseOS/actions/artifacts/$artId/zip")
$req.Headers.Add("Authorization", "Bearer $token")
$req.UserAgent = "curl/8.0"
$req.AllowAutoRedirect = $false
$resp = $req.GetResponse()
$redirectUrl = $resp.GetResponseHeader("Location")
$resp.Close()

Write-Host "Starting download with curl..."
$zipPath = "F:\obraz\neweraseOS-final.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

& "C:\Windows\System32\curl.exe" -fSL --retry 3 --retry-delay 2 -o $zipPath $redirectUrl
if ($LASTEXITCODE -ne 0) {
    throw "Curl download failed with code $LASTEXITCODE"
}

$fileInfo = Get-Item $zipPath
Write-Host "Download complete: $($fileInfo.Length) bytes."

Write-Host "Extracting..."
if (!(Test-Path "F:\obraz\extracted")) {
    New-Item -ItemType Directory -Path "F:\obraz\extracted" -Force | Out-Null
} else {
    Remove-Item "F:\obraz\extracted\*" -Recurse -Force
}

& "C:\Windows\System32\tar.exe" -xf $zipPath -C "F:\obraz\extracted"
if ($LASTEXITCODE -ne 0) {
    throw "Tar extraction failed with code $LASTEXITCODE"
}

$extractedIso = (Get-ChildItem -Path "F:\obraz\extracted" -Filter "*.iso")[0].FullName
Write-Host "Extracted ISO found: $extractedIso"
Copy-Item $extractedIso "F:\obraz\neweraseOS.iso" -Force
Write-Host "Successfully placed at F:\obraz\neweraseOS.iso"
