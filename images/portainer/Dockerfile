# escape=`
FROM busybox as builder
SHELL ["busybox", "sh", "-euxc"]
WORKDIR C:/Users/ContainerUser
ADD https://github.com/portainer/portainer/releases/download/1.14.3/portainer-1.14.3-windows-amd64.tar.gz portainer.tgz
RUN "tar xf portainer.tgz"

FROM microsoft/nanoserver-insider:10.0.16278.1000
EXPOSE 9000
COPY --from=builder /Users/ContainerUser/portainer /app
USER ContainerAdministrator
RUN mkdir c:\data
VOLUME ["C:/data"]
WORKDIR /app
ENTRYPOINT ["/app/portainer.exe"]
