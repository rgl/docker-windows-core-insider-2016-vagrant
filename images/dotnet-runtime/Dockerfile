# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.1.0-download.md
FROM powershell:6.0.2 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/9/1/7/917308D9-6C92-4DA5-B4B1-B4A19451E2D2/dotnet-runtime-2.1.0-win-x64.zip'; `
    $sha512 = '9e30be1d0de2e93ce6854f448f353ed9961e36d1da950e3548ed76e29b993eb2946d7b5db5e9a35baf958e878aead198e703d0ec391269a0ab1f13d354bd5749'; `
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

FROM microsoft/nanoserver-insider:10.0.17709.1000
COPY --from=builder ["/Windows/TEMP/dotnet", "/Program Files/dotnet/"]
USER ContainerAdministrator
RUN setx /m PATH "%PATH%;C:/Program Files/dotnet"
RUN setx /m DOTNET_CLI_TELEMETRY_OPTOUT 1
USER ContainerUser
