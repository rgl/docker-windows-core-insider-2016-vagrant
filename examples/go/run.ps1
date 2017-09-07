Push-Location golang
Write-Output 'building the base golang image...'
$tag = 'golang:1.9-nanoserver-insider'
time {docker build -t $tag .}
docker image ls $tag
docker history $tag
Pop-Location

Push-Location info
Write-Output 'building the go-info image...'
time {docker build -t go-info .}
docker image ls go-info
docker history go-info

Write-Output 'running the go-info container in foreground...'
time {docker run --rm go-info}
Pop-Location
