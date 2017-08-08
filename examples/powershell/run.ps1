cd info

Write-Output 'building the image...'
time {docker build -t powershell-info .}
docker image ls powershell-info
docker history powershell-info

Write-Output 'running the container in foreground...'
time {docker run --rm powershell-info}
