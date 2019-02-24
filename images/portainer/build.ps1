Write-Output 'building the portainer image...'
$tag = 'portainer:1.19.2'
time {docker build -t $tag .}
docker image ls $tag
docker history $tag

Write-Output 'getting the portainer version by running the container in the foreground...'
time {
    docker run `
        --rm `
        --name portainer-test `
        --entrypoint C:/app/portainer.exe `
        $tag `
        --version
}
