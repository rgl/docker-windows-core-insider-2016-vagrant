# escape=`
FROM powershell:6.0.2 AS builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://dl.google.com/go/go1.10.1.windows-amd64.zip'; `
    $sha256 = '17f7664131202b469f4264161ff3cd0796e8398249d2b646bbe4990301afc678'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile go.zip; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash go.zip -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive go.zip .; `
    Write-Host 'Removing...'; `
    Remove-Item go.zip -Force;

FROM powershell:6.0.2
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY --from=builder /Windows/TEMP/go /go/
USER ContainerAdministrator
RUN [Environment]::SetEnvironmentVariable('PATH', ('{0}\go\bin;c:\go\bin;{1}' -f $env:USERPROFILE,$env:PATH), 'Machine')
USER ContainerUser
RUN go version; go env
