# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.4-download.md
FROM powershell:6.0.0-rc.2 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/2/B/2/2B2854E7-7EAE-4FE9-85D2-19ACCD716F18/dotnet-runtime-2.0.4-win-x64.zip'; `
    $sha512 = 'fb5761fa6e38b10bffdff96b841ba1d1bf3d127d2bde0401a2e87f5b31f8bfc48dc8b4a283ef8661fe96c4460ba50e824800c97ccc6858e820bd0e633f85257f'; `
    $filename = Split-Path -Leaf $url; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile $filename; `
    Write-Host ('Verifying sha512 ({0})...' -f $sha512); `
    if ((Get-FileHash $filename -Algorithm sha512).Hash -ne $sha512) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive $filename dotnet; `
    Write-Host 'Removing...'; `
    Remove-Item $filename -Force;

FROM microsoft/nanoserver:1709
COPY --from=builder ["/Users/ContainerUser/AppData/Local/Temp/dotnet", "/Program Files/dotnet/"]
USER ContainerAdministrator
RUN setx /m PATH "%PATH%;C:/Program Files/dotnet"
RUN setx /m DOTNET_CLI_TELEMETRY_OPTOUT 1
USER ContainerUser
