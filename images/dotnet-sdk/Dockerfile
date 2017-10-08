# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.0-download.md
FROM powershell:6.0.0-beta.8
SHELL ["\"C:/Program Files/PowerShell/powershell.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/1/B/4/1B4DE605-8378-47A5-B01B-2C79D6C55519/dotnet-sdk-2.0.0-win-x64.zip'; `
    $sha256 = '541d4dd17023aff14a0aeb6505b200ccabffffc34ab2f629caeb994cedf8afd9'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile dotnet-sdk-2.0.0-win-x64.zip; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash dotnet-sdk-2.0.0-win-x64.zip -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive dotnet-sdk-2.0.0-win-x64.zip 'C:/Program Files/dotnet'; `
    Write-Host 'Removing...'; `
    Remove-Item dotnet-sdk-2.0.0-win-x64.zip -Force;
RUN setx /m PATH ('{0};C:/Program Files/dotnet' -f $env:PATH); `
    setx /m DOTNET_CLI_TELEMETRY_OPTOUT 1;
USER ContainerUser
