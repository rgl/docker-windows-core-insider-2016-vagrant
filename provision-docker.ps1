# see https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon
# see https://docs.docker.com/engine/installation/linux/docker-ce/binaries/#install-server-and-client-binaries-on-windows
# see https://github.com/docker/docker-ce/releases/tag/v17.09.0-ce-rc1

# download install the docker binaries.
$archiveName = 'docker-17.09.0-ce-rc1.zip'
$archiveUrl = "https://download.docker.com/win/static/test/x86_64/$archiveName"
$archiveHash = '767c92420167cbe3d71d174536ff127aaf0db51c0fa2bc04e6a0ee020d4cbc47'
$archivePath = "$env:TEMP\$archiveName"
Invoke-WebRequest $archiveUrl -UseBasicParsing -OutFile $archivePath
$archiveActualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash
if ($archiveActualHash -ne $archiveHash) {
    throw "the $archiveUrl file hash $archiveActualHash does not match the expected $archiveHash"
}
Expand-Archive $archivePath -DestinationPath $env:ProgramFiles
Remove-Item $archivePath

# add docker to the Machine PATH.
[Environment]::SetEnvironmentVariable(
    'PATH',
    "$([Environment]::GetEnvironmentVariable('PATH', 'Machine'));$env:ProgramFiles\docker",
    'Machine')
# add docker to the current process PATH.
$env:PATH += ";$env:ProgramFiles\docker"

# install the docker service and configure it to always restart on failure.
dockerd --register-service
sc.exe failure docker reset= 0 actions= restart/1000

# configure docker through a configuration file.
# see https://docs.docker.com/engine/reference/commandline/dockerd/#windows-configuration-file
$config = @{
    'debug' = $false
    'labels' = @('os=windows')
    'hosts' = @(
        'tcp://0.0.0.0:2375',
        'npipe:////./pipe/docker_engine'
    )
}
mkdir -Force "$env:ProgramData\docker\config" | Out-Null
Set-Content -Encoding ascii "$env:ProgramData\docker\config\daemon.json" ($config | ConvertTo-Json)

Write-Host 'Starting docker...'
Start-Service docker

function Write-Title($title) {
    Write-Output "#`n# $title`n#"
}

Write-Title 'docker version'
docker version

Write-Title 'docker info'
docker info
