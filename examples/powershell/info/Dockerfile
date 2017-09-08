FROM powershell:6.0.0-beta.6
SHELL ["\"C:/Program Files/PowerShell/powershell.exe\"", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /app
COPY *.ps1 ./
USER ContainerUser
RUN .\whoami.ps1
USER ContainerAdministrator
RUN .\whoami.ps1
ENTRYPOINT .\info.ps1
