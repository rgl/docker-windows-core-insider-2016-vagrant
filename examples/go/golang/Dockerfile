# escape=`
FROM microsoft/nanoserver-insider-powershell AS builder
SHELL ["C:/Program Files/PowerShell/PowerShell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://golang.org/dl/go1.8.3.windows-amd64.zip'; `
    $sha256 = 'de026caef4c5b4a74f359737dcb2d14c67ca45c45093755d3b0d2e0ee3aafd96'; `
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
