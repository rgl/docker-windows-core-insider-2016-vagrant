if (!(Test-Path tmp-PowerShell/pwsh.exe)) {
    $url = 'https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-rc.2/PowerShell-6.0.0-rc.2-win-x64.zip'
    $sha256 = 'd225b274923e554e14e4b64ea63e470f44acf11b050c8c12afdfd7e54677c443'
    $filename = Split-Path -Leaf $url
    Write-Host ('Downloading Powershell from {0}...' -f $url)
    Invoke-WebRequest -Uri $url -OutFile $filename
    Write-Host ('Verifying sha256 ({0})...' -f $sha256)
    if ((Get-FileHash $filename -Algorithm sha256).Hash -ne $sha256) {
        Write-Host 'FAILED!'
        Exit 1
    }
    Write-Host 'Expanding...'
    Expand-Archive $filename tmp-PowerShell.tmp
    Remove-Item $filename
    Move-Item tmp-PowerShell.tmp tmp-PowerShell
}

Write-Output 'building the powershell image...'
$tag = 'powershell:6.0.0-rc.2'
time {docker build -t $tag .}
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
