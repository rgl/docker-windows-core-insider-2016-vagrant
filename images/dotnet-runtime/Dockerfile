# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.3.md
FROM powershell:6.0.0-rc as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/5/C/1/5C190037-632B-443D-842D-39085F02E1E8/dotnet-runtime-2.0.3-win-x64.zip'; `
    $sha512 = 'ac4eea527ee8e29286fe46a98be14bf7db3dab6c721eb0c319f80ad3bed57ddadaa719a4325ffd6343d12464d370be90971b1cb81db37d82e90ec7d40b5c3009'; `
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
