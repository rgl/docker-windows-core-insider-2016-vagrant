$version = '6.0.4'
$sha256 = '0b04b63d2b63d4631cf5bd6e531f26b60f3cc1b1db41c8b5360f14776e66f797'
$url = "https://github.com/PowerShell/PowerShell/releases/download/v$version/PowerShell-$version-win-x64.zip"
$filename = "$PWD\$(Split-Path -Leaf $url)"

if (!(Test-Path $filename)) {
    Write-Host "Downloading PowerShell from $url..."
    (New-Object System.Net.WebClient).DownloadFile($url, $filename)
}
Write-Host "Verifying sha256 ($sha256)..."
if ((Get-FileHash $filename -Algorithm sha256).Hash -ne $sha256) {
    Write-Host 'FAILED! Please remove the file and try again...'
    Exit 1
}

Write-Output 'building the powershell image...'
$tag = "powershell:$version"
time {docker build -t $tag --build-arg POWERSHELL_VERSION=$version .}
docker image ls $tag
docker history $tag
Pop-Location

Write-Output 'running the powershell container in the foreground...'
time {
    docker run `
        --rm `
        --name powershell-smoke-test `
        $tag `
        'C:/Program Files/PowerShell/pwsh.exe' `
        -Command '$PSVersionTable'
}
