# see https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/overview
# see https://docs.microsoft.com/en-us/windows-server/manage/admin-center/deployment-guide

# download and install.
$archiveUrl = 'http://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter1804.msi'
$archiveHash = 'b07b3a0bd45b34e695205ddd4b9bc07c23f65d948ae729a279424186989f54d3'
$archiveName = Split-Path -Leaf $archiveUrl
$archivePath = "$env:TEMP\$archiveName"
(New-Object System.Net.WebClient).DownloadFile($archiveUrl, $archivePath)
$archiveActualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash
if ($archiveActualHash -ne $archiveHash) {
    throw "the $archiveUrl file hash $archiveActualHash does not match the expected $archiveHash"
}
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
