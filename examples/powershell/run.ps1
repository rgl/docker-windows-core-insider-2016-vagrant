cd info

Write-Output 'building the container...'
docker build -t powershell-info .

Write-Output 'running the container in foreground...'
docker run --rm powershell-info
