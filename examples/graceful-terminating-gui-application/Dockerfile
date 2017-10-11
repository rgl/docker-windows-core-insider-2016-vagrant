# escape=`
FROM powershell:6.0.0-beta.8 as builder
SHELL ["\"C:/Program Files/PowerShell/powershell.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://github.com/rgl/graceful-terminating-gui-application-windows/releases/download/v0.3.0/graceful-terminating-gui-application-windows.zip'; `
    $sha256 = '5ab0a294c401cc498a27341280fa26f5795cdcb72a9c1208a0edd282881e8350'; `
    Write-Host ('Downloading graceful-terminating-gui-application-windows from {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile graceful-terminating-gui-application-windows.zip; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash graceful-terminating-gui-application-windows.zip -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive graceful-terminating-gui-application-windows.zip .; `
    Write-Host 'Removing unneeded files...'; `
    Remove-Item graceful-terminating-gui-application-windows.zip;

FROM microsoft/nanoserver-insider:10.0.16278.1000
# FROM microsoft/windowsservercore-insider:10.0.16278.1000
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/graceful-terminating-gui-application-windows.exe /app/
RUN mkdir c:\host
VOLUME ["c:/host"]
WORKDIR /host
ENTRYPOINT ["C:/app/graceful-terminating-gui-application-windows.exe", "600"]
