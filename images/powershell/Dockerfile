# escape=`
FROM mcr.microsoft.com/windows/nanoserver:1809 as builder
ARG POWERSHELL_VERSION
COPY ["PowerShell-${POWERSHELL_VERSION}-win-x64.zip", "."]
RUN mkdir "C:/Program Files/PowerShell"
RUN tar xf PowerShell-%POWERSHELL_VERSION%-win-x64.zip -C "C:/Program Files/PowerShell"

FROM mcr.microsoft.com/windows/nanoserver:1809
COPY --from=builder ["C:/Program Files/PowerShell", "C:/Program Files/PowerShell"]
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell'
CMD ["pwsh.exe"]
