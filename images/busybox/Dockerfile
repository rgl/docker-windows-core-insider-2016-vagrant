# escape=`
FROM powershell:6.0.2 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-1986-g701cea96c.exe'; `
    $sha256 = 'fcad08a5fd16a8e55d3e1e57d22d5ab687ea5440a7869a598307251df55f9679'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM microsoft/nanoserver-insider:10.0.17639.1000
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/busybox.exe /Windows/System32/
