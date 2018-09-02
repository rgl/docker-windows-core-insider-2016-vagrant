# escape=`
FROM powershell:6.0.4 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-2294-gf72845d93.exe'; `
    $sha256 = 'ccb3e429f0d7fac32af3e0518bd97b7a3dbcae9c4ed20be5cc4df26e3443e742'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM mcr.microsoft.com/nanoserver-insider:10.0.17744.1001
COPY --from=builder /Windows/TEMP/busybox.exe /Windows/System32/
