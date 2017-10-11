Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
trap {
    Write-Output "ERROR: $_"
    Write-Output (($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1')
    Write-Output (($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1')
    Start-Sleep -Seconds 10
    Exit 1
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
