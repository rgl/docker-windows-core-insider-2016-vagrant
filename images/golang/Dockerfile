# escape=`
FROM powershell:6.0.2 AS builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://storage.googleapis.com/golang/go1.10.windows-amd64.zip'; `
    $sha256 = '210b223031c254a6eb8fa138c3782b23af710a9959d64b551fa81edd762ea167'; `
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
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/go /go/
RUN setx PATH ('{0}\go\bin;c:\go\bin;{1}' -f $env:USERPROFILE,$env:PATH)
RUN go version; go env
