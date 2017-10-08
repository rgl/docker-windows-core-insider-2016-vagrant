if (!(Test-Path tmp-PowerShell/PowerShell.exe)) {
    $url = 'https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-beta.8/PowerShell-6.0.0-beta.8-win-x64.zip'
    $filename = Split-Path -Leaf $url
    $sha256 = 'f21c9a79bc35d326f1cf52aeddccba0dbfcc603af921baaf48f32512be5f4888'
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
$tag = 'powershell:6.0.0-beta.8'
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
        'C:/Program Files/PowerShell/powershell.exe' `
        -Command '$PSVersionTable'
}
