# escape=`
FROM powershell:6.0.0-rc.2 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-1722-g096aee2bb.exe'; `
    $sha256 = '180965b40ec4c9bafbe1672515a19945492f0a2207db39e4a7802516b94c0951'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM microsoft/nanoserver:1709
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/busybox.exe /Windows/System32/
