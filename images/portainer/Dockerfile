# escape=`
FROM mcr.microsoft.com/windows/nanoserver:1809 as builder
WORKDIR C:/Users/ContainerUser
ADD https://github.com/portainer/portainer/releases/download/1.19.2/portainer-1.19.2-windows-amd64.tar.gz portainer.tgz
# TODO verify the tgz sha256sum
RUN tar xf portainer.tgz

FROM mcr.microsoft.com/windows/nanoserver:1809
EXPOSE 9000
COPY --from=builder C:/Users/ContainerUser/portainer C:/app
RUN mkdir C:\data
VOLUME ["C:/data"]
WORKDIR C:/app
ENTRYPOINT ["C:/app/portainer.exe", "--no-auth", "--template-file", "templates.json"]
