if (!(Test-Path tmp-PowerShell/pwsh.exe)) {
    $url = 'https://github.com/PowerShell/PowerShell/releases/download/v6.0.4/PowerShell-6.0.4-win-x64.zip'
    $sha256 = '0b04b63d2b63d4631cf5bd6e531f26b60f3cc1b1db41c8b5360f14776e66f797'
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
$tag = 'powershell:6.0.4'
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
