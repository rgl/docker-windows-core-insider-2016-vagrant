# escape=`
# see https://dotnet.microsoft.com/download/dotnet-core/2.1
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.8/2.1.8.md
FROM powershell:6.1.3 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.visualstudio.microsoft.com/download/pr/9b5aa463-d86c-4f8c-8dbb-26e323021246/3b75b083359c97b79da538cf40b041a0/dotnet-runtime-2.1.8-win-x64.zip'; `
    $sha512 = '42cbfdb97e75e84b075afeb4c943fcf2697f3f0c2d4a5541dead23e6b9d3954a5eff465a4d0b73393257151a905fadb3b022ce883e44d72448f25707218c54f2'; `
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

FROM mcr.microsoft.com/windows/nanoserver:1809
COPY --from=builder ["C:/Windows/TEMP/dotnet", "C:/Program Files/dotnet"]
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\Program Files\dotnet' `
    DOTNET_CLI_TELEMETRY_OPTOUT='1'
