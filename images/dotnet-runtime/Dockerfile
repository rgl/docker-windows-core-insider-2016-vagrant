# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.6-download.md
FROM powershell:6.0.0-rc.2 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/8/D/A/8DA04DA7-565B-4372-BBCE-D44C7809A467/dotnet-runtime-2.0.6-win-x64.zip'; `
    $sha512 = 'c139ee4f8f65581d908efad230111948abb29431c26d058995386d796c71890423ef0654fbc6791ac6e1a889ba2c0bb755c58ac08232d9d009da3e7d55da60d1'; `
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
