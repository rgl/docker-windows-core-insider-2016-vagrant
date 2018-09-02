# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.3/2.1.3.md
FROM powershell:6.0.4
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/E/8/A/E8AF2EE0-5DDA-4420-A395-D1A50EEFD83E/dotnet-sdk-2.1.401-win-x64.zip'; `
    $sha512 = '7d017487c1a11ae4db862b1efa7ba9beb0eabcf5d2467bc4055aa2227a548663a596682ff4adba4688930b22472587f29b83bce9f689efc5e9f4e37f7edda000'; `
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
