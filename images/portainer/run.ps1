$hostIp = (Get-NetAdapter -Name 'vEthernet (nat)' | Get-NetIPAddress -AddressFamily IPv4).IPAddress
$dockerHost = "tcp://${hostIp}:2375"

Write-Output 'Running the portainer container in the background...'
docker `
    run `
    --name portainer `
    --rm `
    -d `
    -p 9000:9000 `
    portainer `
        -H $dockerHost

$containerIp = docker inspect --format '{{.NetworkSettings.Networks.nat.IPAddress}}' portainer
$url = "http://${containerIp}:9000"
Write-Output "Using the container by doing an http request to $url..."
(Invoke-RestMethod $url) -split '\n' | Select-Object -First 8 | ForEach-Object {"    $_"}

Write-Output "The portainer container is available at http://${hostIp}:9000"
Write-Output 'Or inside the VM at http://localhost:9000'
