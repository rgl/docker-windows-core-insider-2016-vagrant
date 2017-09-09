Write-Output 'building the busybox image...'
$tag = 'busybox'
time {docker build -t $tag .}
docker image ls $tag
docker history $tag
Pop-Location

Write-Output 'running the busybox container in the foreground...'
time {
    docker run `
        --rm `
        --name busybox-smoke-test `
        $tag `
        busybox
}
