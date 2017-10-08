# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.0-download.md
FROM powershell:6.0.0-beta.8 as builder
SHELL ["\"C:/Program Files/PowerShell/powershell.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/5/F/0/5F0362BD-7D0A-4A9D-9BF9-022C6B15B04D/dotnet-runtime-2.0.0-win-x64.zip'; `
    $sha256 = '750cee101278cb3d521447a0a2ed11a779a42ee680baa32cd7a6cb5ceb8d08a6'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile dotnet-runtime-2.0.0-win-x64.zip; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash dotnet-runtime-2.0.0-win-x64.zip -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive dotnet-runtime-2.0.0-win-x64.zip dotnet; `
    Write-Host 'Removing...'; `
    Remove-Item dotnet-runtime-2.0.0-win-x64.zip -Force;

FROM microsoft/nanoserver-insider:10.0.16278.1000
COPY --from=builder ["/Users/ContainerUser/AppData/Local/Temp/dotnet", "/Program Files/dotnet/"]
USER ContainerAdministrator
RUN setx /m PATH "%PATH%;C:/Program Files/dotnet"
RUN setx /m DOTNET_CLI_TELEMETRY_OPTOUT 1
USER ContainerUser
