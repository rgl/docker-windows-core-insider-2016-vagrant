FROM powershell:6.1.3
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /app
COPY *.ps1 ./
USER ContainerUser
RUN .\whoami.ps1
USER ContainerAdministrator
RUN .\whoami.ps1
ENTRYPOINT .\info.ps1
