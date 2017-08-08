Push-Location golang
Write-Output 'building the base golang image...'
time {docker build -t golang:1.8-nanoserver-insider .}
docker image ls golang:1.8-nanoserver-insider
docker history golang:1.8-nanoserver-insider
Pop-Location

Push-Location info
Write-Output 'building the go-info image...'
time {docker build -t go-info .}
docker image ls go-info
docker history go-info

Write-Output 'running the go-info container in foreground...'
time {docker run --rm go-info}
Pop-Location
