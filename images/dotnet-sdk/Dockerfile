# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.1.0-download.md
FROM powershell:6.0.2
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/8/8/5/88544F33-836A-49A5-8B67-451C24709A8F/dotnet-sdk-2.1.300-win-x64.zip'; `
    $sha512 = '4aa6ff6aa51e1d71733944e10fd9e37647a58df7efbc76f432b8c3ffa3f617f9da36f72532175a1e765dbaf4598a14350017342d5f776dfe8e25d5049696d003'; `
    $filename = Split-Path -Leaf $url; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile $filename; `
    Write-Host ('Verifying sha512 ({0})...' -f $sha512); `
    if ((Get-FileHash $filename -Algorithm sha512).Hash -ne $sha512) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive $filename 'C:/Program Files/dotnet'; `
    Write-Host 'Removing...'; `
    Remove-Item $filename -Force;
RUN setx /m PATH ('{0};C:/Program Files/dotnet' -f $env:PATH); `
    setx /m DOTNET_CLI_TELEMETRY_OPTOUT 1;
USER ContainerUser
