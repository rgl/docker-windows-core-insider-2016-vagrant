# escape=`
FROM microsoft/nanoserver-insider:10.0.17623.1002 as builder
WORKDIR C:/Users/ContainerUser
ADD https://github.com/portainer/portainer/releases/download/1.16.4/portainer-1.16.4-windows-amd64.tar.gz portainer.tgz
RUN tar xf portainer.tgz

FROM microsoft/nanoserver-insider:10.0.17623.1002
EXPOSE 9000
COPY --from=builder /Users/ContainerUser/portainer /app
USER ContainerAdministrator
RUN mkdir c:\data
VOLUME ["C:/data"]
WORKDIR /app
ENTRYPOINT ["/app/portainer.exe", "--no-auth"]
