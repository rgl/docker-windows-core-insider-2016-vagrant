@(
    'mcr.microsoft.com/windows/nanoserver:1809'
    'mcr.microsoft.com/windows/servercore:1809'
    'mcr.microsoft.com/windows:1809'
) | ForEach-Object {
    Set-Content `
        -Encoding utf8 `
        -Path Dockerfile.tmp `
        -Value (
            (Get-Content -Raw Dockerfile) `
                -replace 'FROM \$BASEIMAGE',"FROM $_"
        )

    $dataPath = 'C:\graceful-terminating-console-application'
    mkdir -Force $dataPath | Out-Null
    Remove-Item -ErrorAction SilentlyContinue -Force "$dataPath\graceful-terminating-console-application-windows.log"

    Write-Output 'building the container...'
    time {docker build -t graceful-terminating-console-application --file Dockerfile.tmp .}

    Write-Output 'getting the container history...'
    docker history graceful-terminating-console-application

    Write-Output 'running the container in background...'
    try {docker rm --force graceful-terminating-console-application} catch {}
    # TODO there seems to be an EmulateConsole property that we can pass to docker... check it out! is -t enough?
    time {docker run -d --volume "${dataPath}:C:\host" --name graceful-terminating-console-application graceful-terminating-console-application}

    Write-Output 'sleeping a bit before stopping the container...'
    Start-Sleep -Seconds 15
    Write-Output 'stopping the container...'
    # XXX docker/windows seems to ignore the --time argument...
    docker stop --time 600 graceful-terminating-console-application

    Write-Output 'getting the container logs...'
    docker logs graceful-terminating-console-application | ForEach-Object {"    $_"}

    Write-Output 'getting the log file...'
    Get-Content "$dataPath\graceful-terminating-console-application-windows.log"
}

Remove-Item -Force Dockerfile.tmp
