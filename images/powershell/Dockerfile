# escape=`
FROM mcr.microsoft.com/nanoserver-insider:10.0.17744.1001 as builder
ARG POWERSHELL_VERSION
COPY ["PowerShell-${POWERSHELL_VERSION}-win-x64.zip", "."]
RUN mkdir "C:/Program Files/PowerShell"
RUN tar xf PowerShell-%POWERSHELL_VERSION%-win-x64.zip -C "C:/Program Files/PowerShell"

FROM mcr.microsoft.com/nanoserver-insider:10.0.17744.1001
COPY --from=builder ["C:/Program Files/PowerShell", "C:/Program Files/PowerShell"]
CMD ["\"C:/Program Files/PowerShell/pwsh.exe\""]
