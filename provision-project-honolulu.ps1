# see https://docs.microsoft.com/en-us/windows-server/manage/honolulu/honolulu
# see https://docs.microsoft.com/en-us/windows-server/manage/honolulu/deployment-guide

# download and install.
$archiveUrl = 'http://download.microsoft.com/download/E/8/A/E8A26016-25A4-49EE-8200-E4BCBF292C4A/HonoluluTechnicalPreview1709-20016.msi'
$archiveHash = 'c17364d3064890f02577d66b5b5819dd038754f3d8c827654148e3b2a907461c'
$archiveName = Split-Path -Leaf $archiveUrl
$archivePath = "$env:TEMP\$archiveName"
Invoke-WebRequest $archiveUrl -UseBasicParsing -OutFile $archivePath
$archiveActualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash
if ($archiveActualHash -ne $archiveHash) {
    throw "the $archiveUrl file hash $archiveActualHash does not match the expected $archiveHash"
}
msiexec /i $archivePath `
    /qn `
    /L*v "$env:TEMP\honolulu.log" `
    SME_PORT=8443 `
    SSL_CERTIFICATE_OPTION=generate `
    | Out-String -Stream
if ($LASTEXITCODE) {
    throw "$archiveName installation failed with exit code $LASTEXITCODE. See $env:TEMP\honolulu.log."
}
Remove-Item $archivePath
