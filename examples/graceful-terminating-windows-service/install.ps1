$serviceName = 'graceful-terminating-windows-service'
# $serviceUsername = "NT SERVICE\$serviceName"
$serviceUsername = 'NT AUTHORITY\SYSTEM'
# $serviceUsername = 'USER MANAGER\ContainerUser'
# $serviceUsername = 'User Manager\ContainerAdministrator'

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
    Write-Host "$serviceName service has the $(sc.exe showsid $serviceName) SID."
}

Write-Host "Configuring the $serviceName service to run as the $serviceUsername account..."
$result = sc.exe config $serviceName obj= $serviceUsername
if ($result -ne '[SC] ChangeServiceConfig SUCCESS') {
    throw "sc.exe config failed with $result"
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

# see WaitToKillServiceTimeout at https://technet.microsoft.com/en-us/library/cc976045.aspx
Write-Host 'Maximum time [ms] that Windows waits before killing a service:'
(Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name WaitToKillServiceTimeout).WaitToKillServiceTimeout
# TODO remove next line?
# Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name WaitToKillServiceTimeout -Value '450000'

# see WaitToKillAppTimeout at https://technet.microsoft.com/en-us/library/cc978624.aspx
# NB this overriddes HKCU:\Control Panel\Desktop
if (!(Test-Path 'HKU:\.DEFAULT\Control Panel\Desktop')) {
    New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS | Out-Null
}
Write-Host 'Maximum time [ms] that Windows waits before killing a application:'
$waitToKillAppTimeoutItemProperty = Get-ItemProperty -Path 'HKU:\.DEFAULT\Control Panel\Desktop' -Name WaitToKillAppTimeout -ErrorAction SilentlyContinue
if ($waitToKillAppTimeoutItemProperty) {
    $waitToKillAppTimeoutItemProperty.WaitToKillAppTimeout
} else {
    'unknown' # TFM says its 20s. BUT then again, it also says, WaitToKillAppTimeout is 20s, but in a container its 5s.
}
# TODO remove next line?
# New-ItemProperty -Force -Path 'HKU:\.DEFAULT\Control Panel\Desktop' -Name WaitToKillAppTimeout -Value '450000' -PropertyType String
