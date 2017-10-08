Write-Output 'building the portainer image...'
time {docker build -t portainer .}
docker image ls portainer
docker history portainer
