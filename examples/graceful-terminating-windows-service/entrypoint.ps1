Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
trap {
    Write-Output "ERROR: $_"
    Write-Output (($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1')
    Write-Output (($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1')
    Start-Sleep -Seconds 10
    Exit 1
}

# see WaitToKillServiceTimeout at https://technet.microsoft.com/en-us/library/cc976045.aspx
Write-Host 'Maximum time [ms] that Windows waits before killing a service:'
(Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name WaitToKillServiceTimeout).WaitToKillServiceTimeout
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


$serviceName = 'graceful-terminating-windows-service'

Write-Output 'Starting the service in background...'
Start-Service $serviceName

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

while ($true) {
    Write-Output 'Sleeping...'
    Start-Sleep -Seconds 5
}
