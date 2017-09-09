# escape=`
FROM powershell:6.0.0-beta.6 as builder
SHELL ["\"C:/Program Files/PowerShell/powershell.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-1601-gc87d9b4b2.exe'; `
    $sha256 = '65cc7e6866447ac2a7ff2f19386726a9674cc0788dc660225fd92b5a3cf82ead'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM microsoft/nanoserver-insider:10.0.16278.1000
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/busybox.exe /Windows/System32/
