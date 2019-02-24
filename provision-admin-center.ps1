# see https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/overview
# see https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/deploy/install

# download and install.
Write-Host 'Downloading...'
$archiveUrl = 'https://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter1809.5.msi'
$archiveHash = 'f37d6123170f2bd78ef8b0fc5458000ea4e513cbd52208e5d66f517e00321dfa'
$archiveName = Split-Path -Leaf $archiveUrl
$archivePath = "$env:TEMP\$archiveName"
(New-Object System.Net.WebClient).DownloadFile($archiveUrl, $archivePath)
$archiveActualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash
if ($archiveActualHash -ne $archiveHash) {
    throw "the $archiveUrl file hash $archiveActualHash does not match the expected $archiveHash"
}
Write-Host 'Installing...'
msiexec /i $archivePath `
    /qn `
    /L*v "$env:TEMP\admin-center.log" `
    SME_PORT=8443 `
    SSL_CERTIFICATE_OPTION=generate `
    | Out-String -Stream
if ($LASTEXITCODE) {
    throw "$archiveName installation failed with exit code $LASTEXITCODE. See $env:TEMP\admin-center.log."
}
Remove-Item $archivePath
Write-Host 'Done.'
