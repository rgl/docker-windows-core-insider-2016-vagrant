# escape=`
FROM powershell:6.0.2 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-2187-g28ade29e9.exe'; `
    $sha256 = 'b286e0bdfce69a57725be40de7d8919b9e7e3face75bdaee3b94079b2835f0f0'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM microsoft/nanoserver-insider:10.0.17677.1000
COPY --from=builder /Windows/TEMP/busybox.exe /Windows/System32/
