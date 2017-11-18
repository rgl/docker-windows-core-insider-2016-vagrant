Write-Output 'building the dotnet-runtime image...'
$tag = 'dotnet-runtime:2.0.3'
time {docker build -t $tag .}
docker image ls $tag
docker history $tag
Pop-Location

Write-Output 'running the dotnet-runtime container in the foreground...'
time {
    docker run `
        --rm `
        --name dotnet-runtime-smoke-test `
        $tag `
        dotnet --info
}
