$dataPath = 'C:\graceful-terminating-windows-service'
mkdir -Force $dataPath | Out-Null
Remove-Item -ErrorAction SilentlyContinue -Force "$dataPath\graceful-terminating-windows-service.log"

Write-Output 'building the container...'
time {docker build -t graceful-terminating-windows-service .}

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
