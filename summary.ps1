Write-Title 'docker version'
docker version

Write-Title 'docker info'
docker info

Write-Title 'docker images'
docker images --filter 'dangling=false'
