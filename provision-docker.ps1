# see https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon
# see https://docs.docker.com/engine/installation/linux/docker-ce/binaries/#install-server-and-client-binaries-on-windows
# see https://github.com/docker/docker-ce/releases/tag/v18.05.0-ce

# download install the docker binaries.
$archiveVersion = '18.05.0'
$archiveName = "docker-$archiveVersion-ce.zip"
$archiveUrl = "https://github.com/rgl/docker-ce-windows-binaries-vagrant/releases/download/v$archiveVersion-ce/$archiveName"
$archiveHash = '989640cc4510d100d42e7fb05cbe164b965be24d6063b1276c7c38121be18979'
$archivePath = "$env:TEMP\$archiveName"
Write-Host 'Downloading docker...'
(New-Object System.Net.WebClient).DownloadFile($archiveUrl, $archivePath)
$archiveActualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash
if ($archiveActualHash -ne $archiveHash) {
    throw "the $archiveUrl file hash $archiveActualHash does not match the expected $archiveHash"
}
Expand-Archive $archivePath -DestinationPath $env:ProgramFiles
Remove-Item $archivePath

<#
# download and install LinuxKit for LCOW.
# see https://github.com/Microsoft/opengcs
# see https://blog.docker.com/2017/09/preview-linux-containers-on-windows/
# see https://github.com/friism/linuxkit/releases
[Environment]::SetEnvironmentVariable('LCOW_SUPPORTED', '1', 'Machine')
$archiveUrl = 'https://github.com/friism/linuxkit/releases/download/preview-1/linuxkit.zip'
$archiveHash = '387ede46fd61657a70bc6311cf49282ec965ab9fec7ddcf91febb19e98df9628'
$archiveName = Split-Path -Leaf $archiveUrl
$archivePath = "$env:TEMP\$archiveName"
Invoke-WebRequest $archiveUrl -UseBasicParsing -OutFile $archivePath
$archiveActualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash
if ($archiveActualHash -ne $archiveHash) {
    throw "the $archiveUrl file hash $archiveActualHash does not match the expected $archiveHash"
}
Expand-Archive $archivePath -DestinationPath "$env:ProgramFiles\Linux Containers"
Remove-Item $archivePath
#>

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
    'experimental' = $true # for LCOW.
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

Write-Title 'windows version'
# BuildLabEx is something like:
#      17709.1000.amd64fre.rs_prerelease.180629-1430
#      ^^^^^^^^^^ ^^^^^^^^ ^^^^^^^^^^^^^ ^^^^^^ ^^^^
#      build      platform branch        date   time (redmond tz)
# see https://channel9.msdn.com/Blogs/One-Dev-Minute/Decoding-Windows-Build-Numbers
(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name BuildLabEx).BuildLabEx

Write-Host 'Downloading the base images...'
docker pull microsoft/nanoserver-insider:10.0.17709.1000

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
