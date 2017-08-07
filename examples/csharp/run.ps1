cd info

Write-Output 'building the container...'
docker build -t csharp-info .

Write-Output 'running the container in foreground...'
docker run --rm csharp-info
