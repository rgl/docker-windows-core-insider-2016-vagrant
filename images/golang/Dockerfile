# escape=`
FROM powershell:6.0.0-rc AS builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://storage.googleapis.com/golang/go1.9.2.windows-amd64.zip'; `
    $sha256 = '682ec3626a9c45b657c2456e35cadad119057408d37f334c6c24d88389c2164c'; `
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

FROM powershell:6.0.0-rc
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY --from=builder /Users/ContainerUser/AppData/Local/Temp/go /go/
RUN setx PATH ('{0}\go\bin;c:\go\bin;{1}' -f $env:USERPROFILE,$env:PATH)
RUN go version; go env
