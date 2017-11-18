# escape=`
FROM powershell:6.0.0-rc as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-1668-g236e13e3d.exe'; `
    $sha256 = '3945102a2fb4da1091f55ace2b51836e5dfc3224098d46a02a28891a2a7aba7a'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM microsoft/nanoserver:1709
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/busybox.exe /Windows/System32/
