cd info

Write-Output 'building the image...'
time {docker build -t busybox-info .}
docker image ls busybox-info
docker history busybox-info

Write-Output 'running the container in foreground...'
time {docker run --rm busybox-info}
