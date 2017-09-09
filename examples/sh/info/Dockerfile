# escape=`
FROM busybox
USER ContainerAdministrator
SHELL ["busybox", "sh"]
WORKDIR "/app"
COPY *.sh ./
ENTRYPOINT info.sh
