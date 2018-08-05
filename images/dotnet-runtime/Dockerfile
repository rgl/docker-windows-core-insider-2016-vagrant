# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.1.2-download.md
FROM powershell:6.0.3 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/1/f/7/1f7755c5-934d-4638-b89f-1f4ffa5afe89/dotnet-runtime-2.1.2-win-x64.zip'; `
    $sha512 = '9e67c62feb34aeb52a45d0e623d1ad098637a322545956eb5e6de2287ddad2412b766c492ae5a7dddc123a4cb47cfc51d9bb10d0e30c007ec3fc90666f9733c8'; `
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

FROM mcr.microsoft.com/nanoserver-insider:10.0.17723.1000
COPY --from=builder ["/Windows/TEMP/dotnet", "/Program Files/dotnet/"]
USER ContainerAdministrator
RUN setx /m PATH "%PATH%;C:/Program Files/dotnet"
RUN setx /m DOTNET_CLI_TELEMETRY_OPTOUT 1
USER ContainerUser
