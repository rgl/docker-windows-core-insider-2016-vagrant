# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.400-SDK/2.1.400-sdk-download.md
FROM powershell:6.0.4
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/9/D/2/9D2354BE-778B-42D6-BA4F-3CEF489A4FDE/dotnet-sdk-2.1.400-win-x64.zip'; `
    $sha512 = 'c76e80a33ec3c4227e8f5ed2b54c1023949df8aa0563aead69e45aa2173ee4bccbd0ae75c95fda2f22bc22c1bd2f14275400dfa99e6aab58cca30e3e107d438e'; `
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
