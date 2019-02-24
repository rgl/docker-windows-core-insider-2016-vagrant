# escape=`
# see https://dotnet.microsoft.com/download/dotnet-core/2.1
# see https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1.8/2.1.8.md
FROM powershell:6.1.3 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://download.visualstudio.microsoft.com/download/pr/88364f95-160b-4820-9a5b-1d00b619dee7/5021f130569e524eacc2e3a8e6933e62/dotnet-sdk-2.1.504-win-x64.zip'; `
    $sha512 = 'a7a19bba1b48f47e24da5daa3e73c9a3279613813843fa3513c01f4d1bb6026699df131cc624ee3fae49775282016e0dff62e3f62e670fe843ff6e66a3387b20'; `
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

FROM powershell:6.1.3
COPY --from=builder ["C:/Program Files/dotnet", "C:/Program Files/dotnet"]
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\Program Files\dotnet' `
    DOTNET_CLI_TELEMETRY_OPTOUT='1'
