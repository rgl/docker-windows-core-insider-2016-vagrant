# escape=`
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.3/2.1.3.md
FROM powershell:6.0.4 as builder
SHELL ["\"C:/Program Files/PowerShell/pwsh.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.microsoft.com/download/6/E/B/6EBD972D-2E2F-41EB-9668-F73F5FDDC09C/dotnet-runtime-2.1.3-win-x64.zip'; `
    $sha512 = 'eec3465a1dfecc3890e8c07d45198352a9ef4026bebc867ca8723ddf4bf30e83b79dfae4c5b8800a4b1b83d38c63be06b8ebf7c5dce87cf7108cbb83b169b47f'; `
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

FROM mcr.microsoft.com/nanoserver-insider:10.0.17733.1000
COPY --from=builder ["/Windows/TEMP/dotnet", "/Program Files/dotnet/"]
USER ContainerAdministrator
RUN setx /m PATH "%PATH%;C:/Program Files/dotnet"
RUN setx /m DOTNET_CLI_TELEMETRY_OPTOUT 1
USER ContainerUser
