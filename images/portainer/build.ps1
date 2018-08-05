Write-Output 'building the portainer image...'
$tag = 'portainer:1.18.1'
time {docker build -t $tag .}
docker image ls $tag
docker history $tag
