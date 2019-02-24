@(
    'powershell:6.1.3' # NB this is based on 'mcr.microsoft.com/windows/nanoserver:1809'
    'mcr.microsoft.com/windows/servercore:1809'
    'mcr.microsoft.com/windows:1809'
) | ForEach-Object {
    $replacement = "FROM $_`nSHELL [`"PowerShell.exe`", `"-ExecutionPolicy`", `"Bypass`", `"-Command`", `"`$ErrorActionPreference = 'Stop'; `$ProgressPreference = 'SilentlyContinue';`"]"
    if ($_ -match 'powershell:') {
        $replacement = $replacement -creplace 'PowerShell','pwsh'
    }
    Set-Content `
        -Encoding utf8 `
        -Path Dockerfile.tmp `
        -Value (
            (Get-Content -Raw Dockerfile) `
                -replace 'FROM \$BASEIMAGE',$replacement
        )

    $dataPath = 'C:\graceful-terminating-windows-service'
    mkdir -Force $dataPath | Out-Null
    Remove-Item -ErrorAction SilentlyContinue -Force "$dataPath\graceful-terminating-windows-service.log"

    Write-Output 'building the container...'
    time {docker build -t graceful-terminating-windows-service --file Dockerfile.tmp .}

    Write-Output 'getting the container history...'
    docker history graceful-terminating-windows-service

    Write-Output 'running the container in background...'
    try {docker rm --force graceful-terminating-windows-service} catch {}
    time {docker run -d --volume "${dataPath}:C:\host" --name graceful-terminating-windows-service graceful-terminating-windows-service}

    Write-Output 'sleeping a bit before stopping the container...'
    Start-Sleep -Seconds 15
    Write-Output 'stopping the container...'
    docker stop --time 600 graceful-terminating-windows-service

    Write-Output 'getting the container logs...'
    docker logs graceful-terminating-windows-service | ForEach-Object {"    $_"}

    Write-Output 'getting the log file...'
    Get-Content "$dataPath\graceful-terminating-windows-service.log"
}

Remove-Item -Force Dockerfile.tmp
