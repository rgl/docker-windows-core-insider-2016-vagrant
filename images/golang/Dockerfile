# escape=`
FROM powershell:6.0.4 AS builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://dl.google.com/go/go1.11.windows-amd64.zip'; `
    $sha256 = '29f9291270f0b303d0b270f993972ead215b1bad3cc674a0b8a09699d978aeb4'; `
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

FROM powershell:6.0.4
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY --from=builder /Windows/TEMP/go /go/
USER ContainerAdministrator
RUN [Environment]::SetEnvironmentVariable('PATH', ('{0}\go\bin;c:\go\bin;{1}' -f $env:USERPROFILE,$env:PATH), 'Machine')
USER ContainerUser
RUN go version; go env
