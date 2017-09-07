# escape=`
FROM microsoft/nanoserver-insider-powershell AS builder
SHELL ["C:/Program Files/PowerShell/PowerShell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://storage.googleapis.com/golang/go1.9.windows-amd64.zip'; `
    $sha256 = '874b144b994643cff1d3f5875369d65c01c216bb23b8edddf608facc43966c8b'; `
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

FROM microsoft/nanoserver-insider-powershell
SHELL ["C:/Program Files/PowerShell/PowerShell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/go /go/
RUN setx PATH ('{0}\go\bin;c:\go\bin;{1}' -f $env:USERPROFILE,$env:PATH)
RUN go version; go env
