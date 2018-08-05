# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.1.2-download.md
FROM powershell:6.0.3
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/4/0/9/40920432-3302-47a8-b13c-bbc4848ad114/dotnet-sdk-2.1.302-win-x64.zip'; `
    $sha512 = 'a8a74d3329191df6357a00e26591cdc64153970e0cf42f820ade0fb520c9cb0e6ab16ab357dc9538a8c488245c505930b4b0a6b63721e4eebf8682613a63441e'; `
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
