$dataPath = 'C:\graceful-terminating-gui-application'
mkdir -Force $dataPath | Out-Null
Remove-Item -ErrorAction SilentlyContinue -Force "$dataPath\graceful-terminating-gui-application-windows.log"

Write-Output 'building the container...'
time {docker build -t graceful-terminating-gui-application .}

Write-Output 'getting the container history...'
docker history graceful-terminating-gui-application

Write-Output 'running the container in background...'
try {docker rm --force graceful-terminating-gui-application} catch {}
time {docker run -d --volume "${dataPath}:C:\host" --name graceful-terminating-gui-application graceful-terminating-gui-application}

Write-Output 'sleeping a bit before stopping the container...'
Start-Sleep -Seconds 15
Write-Output 'stopping the container...'
docker stop --time 600 graceful-terminating-gui-application

Write-Output 'getting the container logs...'
docker logs graceful-terminating-gui-application | ForEach-Object {"    $_"}

Write-Output 'getting the log file...'
Get-Content "$dataPath\graceful-terminating-gui-application-windows.log"
