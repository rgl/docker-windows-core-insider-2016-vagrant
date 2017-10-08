# see https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon
# see https://docs.docker.com/engine/installation/linux/docker-ce/binaries/#install-server-and-client-binaries-on-windows
# see https://github.com/docker/docker-ce/releases/tag/v17.10.0-ce-rc1

# download install the docker binaries.
$archiveName = 'docker-17.10.0-ce-rc1.zip'
$archiveUrl = "https://download.docker.com/win/static/test/x86_64/$archiveName"
$archiveHash = 'a7ca57420e70ef47eeb320eeac2c8bdaea5d70c7b6b92d946fee2e900e6c6b3e'
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

Write-Host 'Creating the firewall rule to allow inbound TCP/IP access to the Docker Engine port 2375...'
New-NetFirewallRule `
    -Name 'Docker-Engine-In-TCP' `
    -DisplayName 'Docker Engine (TCP-In)' `
    -Direction Inbound `
    -Enabled True `
    -Protocol TCP `
    -LocalPort 2375 `
    | Out-Null

Write-Host 'Downloading the base images...'
docker pull microsoft/nanoserver-insider:10.0.16278.1000

Write-Title 'docker version'
docker version

Write-Title 'docker info'
docker info

# see https://docs.docker.com/engine/api/v1.32/
# see https://github.com/moby/moby/tree/master/api
Write-Title 'docker info (obtained from http://localhost:2375/info)'
$infoResponse = Invoke-WebRequest 'http://localhost:2375/info' -UseBasicParsing
$info = $infoResponse.Content | ConvertFrom-Json
Write-Output "Engine Version:     $($info.ServerVersion)"
Write-Output "Engine Api Version: $($infoResponse.Headers['Api-Version'])"
