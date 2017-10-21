# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.0-download.md
FROM powershell:6.0.0-beta.8
SHELL ["\"C:/Program Files/PowerShell/powershell.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/7/3/A/73A3E4DC-F019-47D1-9951-0453676E059B/dotnet-sdk-2.0.2-win-x64.zip'; `
    $sha512 = '4864a36d3be9d460a17d0ebe9d03b17ce224ec18880bcdbc087889f32ddfc2cf3753a1ab7d0414b1e73e863e0d10f5a8381e80effc7f7c0a50600dd82a1f0048'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile dotnet-sdk-2.0.2-win-x64.zip; `
    Write-Host ('Verifying sha512 ({0})...' -f $sha512); `
    if ((Get-FileHash dotnet-sdk-2.0.2-win-x64.zip -Algorithm sha512).Hash -ne $sha512) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    }; `
    Write-Host 'Expanding...'; `
    Expand-Archive dotnet-sdk-2.0.2-win-x64.zip 'C:/Program Files/dotnet'; `
    Write-Host 'Removing...'; `
    Remove-Item dotnet-sdk-2.0.2-win-x64.zip -Force;
RUN setx /m PATH ('{0};C:/Program Files/dotnet' -f $env:PATH); `
    setx /m DOTNET_CLI_TELEMETRY_OPTOUT 1;
USER ContainerUser
