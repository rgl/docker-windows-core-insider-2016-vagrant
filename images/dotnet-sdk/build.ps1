Write-Output 'building the dotnet-sdk image...'
$tag = 'dotnet-sdk:2.1.401'
time {docker build -t $tag .}
docker image ls $tag
docker history $tag
Pop-Location

Write-Output 'running the dotnet-sdk container in the foreground...'
time {
    docker run `
        --rm `
        --name dotnet-sdk-smoke-test `
        $tag `
        dotnet --info
}
