Write-Output 'building the dotnet-sdk image...'
$tag = 'dotnet-sdk:2.1.504'
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

Write-Output 'dotnet-sdk container environment variables:'
$config = docker inspect $tag | ConvertFrom-Json
$config.ContainerConfig.Env
