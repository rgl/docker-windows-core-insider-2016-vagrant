if (!(Test-Path tmp-PowerShell/pwsh.exe)) {
    $url = 'https://github.com/PowerShell/PowerShell/releases/download/v6.0.2/PowerShell-6.0.2-win-x64.zip'
    $sha256 = '8cb153e540ed9d9a7fe00cb3d1fe94a0ed089b574fd02e816ab2bb066f4c4f89'
    $filename = "$PWD\$(Split-Path -Leaf $url)"
    Write-Host ('Downloading Powershell from {0}...' -f $url)
    (New-Object System.Net.WebClient).DownloadFile($url, $filename)
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
$tag = 'powershell:6.0.2'
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
