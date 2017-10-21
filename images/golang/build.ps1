Write-Output 'building the golang image...'
$tag = 'golang:1.9.1'
time {docker build -t $tag .}
docker image ls $tag
docker history $tag
Pop-Location

Write-Output 'running the golang container in the foreground...'
time {
    docker run `
        --rm `
        --name golang-smoke-test `
        $tag `
        go env
}
