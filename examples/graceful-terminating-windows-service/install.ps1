$serviceName = 'graceful-terminating-windows-service'
#$serviceUsername = "NT SERVICE\$serviceName"
$serviceUsername = 'SYSTEM'

Write-Host "Creating the $serviceName service..."
$result = sc.exe create $serviceName binPath= "$PWD/graceful-terminating-windows-service.exe 600 c:/host t"
if ($result -ne '[SC] CreateService SUCCESS') {
    throw "sc.exe sidtype failed with $result"
}

if ($serviceUsername.StartsWith('NT SERVICE\')) {
    Write-Host "Configuring the $serviceName service to use a Windows managed service account..."
    $result = sc.exe sidtype $serviceName unrestricted
    if ($result -ne '[SC] ChangeServiceConfig2 SUCCESS') {
        throw "sc.exe sidtype failed with $result"
    }
    $result = sc.exe config $serviceName obj= $serviceUsername
    if ($result -ne '[SC] ChangeServiceConfig SUCCESS') {
        throw "sc.exe config failed with $result"
    }
    Write-Host "$serviceName service has the $(sc.exe showsid $serviceName) SID."
}

Write-Host "Configuring the $serviceName service to restart on any failure..."
$result = sc.exe failure $serviceName reset= 0 actions= restart/1000
if ($result -ne '[SC] ChangeServiceConfig2 SUCCESS') {
    throw "sc.exe failure failed with $result"
}

Write-Host "Service $serviceName status is:"
Get-Service $serviceName | ForEach-Object {
    New-Object PSObject -Property @{
        Name = $_.Name
        DisplayName = $_.DisplayName
        ImagePath = (Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\$($_.Name)" -Name ImagePath).ImagePath
        Status = $_.Status
        StartType = $_.StartType
        ServiceType = $_.ServiceType
    }
} | Format-List Name,DisplayName,ImagePath,Status,StartType,ServiceType
