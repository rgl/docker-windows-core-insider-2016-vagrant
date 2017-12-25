# escape=`
FROM powershell:6.0.0-rc.2 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-1709-g65e9c0ad9.exe'; `
    $sha256 = '664dd9ec492953f523b7e60406d93f37c4875b8c29f6df5b056916405e6d3c04'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM microsoft/nanoserver:1709
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/busybox.exe /Windows/System32/
