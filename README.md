This is a Docker on Windows Server 1803 Insider Vagrant environment for playing with Windows containers.

**THIS BRANCH WILL BE REBASED ON master FROM TIME TO TIME**

## Docker images

This environment builds and uses the following images:

```
REPOSITORY                                    TAG                 IMAGE ID            CREATED             SIZE
busybox-info                                  latest              06ef826886b6        11 seconds ago      239MB
go-info                                       latest              e92aab453124        24 seconds ago      241MB
csharp-info                                   latest              8bfd2d72ea5e        52 seconds ago      311MB
powershell-info                               latest              11c08e30ace8        4 minutes ago       376MB
batch-info                                    latest              e13275d2c443        5 minutes ago       239MB
portainer                                     1.19.1              eaf6eb69c5ea        5 minutes ago       282MB
busybox                                       latest              2a06d19a36a0        6 minutes ago       239MB
golang                                        1.11                a2b66c8550af        6 minutes ago       717MB
dotnet-sdk                                    2.1.401             cafb1d1a4d39        10 minutes ago      694MB
dotnet-runtime                                2.1.3               58de4aac28a2        11 minutes ago      311MB
powershell                                    6.0.4               b5bad8e5a539        12 minutes ago      372MB
mcr.microsoft.com/nanoserver-insider          10.0.17744.1001     a0128f6324b4        12 days ago         239MB
mcr.microsoft.com/windowsservercore-insider   10.0.17744.1001     f548cf725ce4        12 days ago         3.43GB
mcr.microsoft.com/windows-insider             10.0.17744.1001     a0981c329b9c        12 days ago         8.32GB
```


# Usage

Install the [Base Windows Server Insider 2019 Box](https://github.com/rgl/windows-2016-vagrant).

Install the required plugins:

```bash
vagrant plugin install vagrant-reload
```

Then launch the environment:

```bash
vagrant up --provider=virtualbox # or --provider=libvirt
```

At the end of the provision the [examples](examples/) are run.

The Docker Engine API endpoint is available at http://10.0.0.3:2375.

[Portainer](https://portainer.io/) is available at http://10.0.0.3:9000.

[Windows Admin Center](https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/overview) is available at https://10.0.0.3:8443.


# Graceful Container Shutdown

**Windows containers cannot be gracefully shutdown** because they are forcefully terminated after a while. Check the [moby issue 25982](https://github.com/moby/moby/issues/25982) for progress.

The next table describes whether a `docker stop --time 600 <container>` will graceful shutdown a container that is running a [console](https://github.com/rgl/graceful-terminating-console-application-windows/), [gui](https://github.com/rgl/graceful-terminating-gui-application-windows/), or [service](https://github.com/rgl/graceful-terminating-windows-service/) app.

| base image        | app     | behaviour                                                                                    |
| ----------------- | ------- | -------------------------------------------------------------------------------------------- |
| nanoserver        | console | receives the `CTRL_SHUTDOWN_EVENT` notification but is killed after about 5 seconds          |
| windowsservercore | console | receives the `CTRL_SHUTDOWN_EVENT` notification but is killed after about 5 seconds          |
| nanoserver        | gui     | fails to run because there is no GUI support in nano                                         |
| windowsservercore | gui     | **does not receive the shutdown notification**                                               |
| nanoserver        | service | receives the `SERVICE_CONTROL_PRESHUTDOWN` notification but is killed after about 10 seconds |
| windowsservercore | service | receives the `SERVICE_CONTROL_PRESHUTDOWN` notification but is killed after about 10 seconds |

You can launch these example containers from host as:

```bash
vagrant execute --sudo -c '/vagrant/ps.ps1 examples/graceful-terminating-console-application/run.ps1'
vagrant execute --sudo -c '/vagrant/ps.ps1 examples/graceful-terminating-gui-application/run.ps1'
vagrant execute --sudo -c '/vagrant/ps.ps1 examples/graceful-terminating-windows-service/run.ps1'
```


# Troubleshoot

* Restart the docker daemon in debug mode and watch the logs:
  * set `"debug": true` inside the `$env:ProgramData\docker\config\daemon.json` file
  * restart docker with `Restart-Service docker`
  * watch the logs with `Get-EventLog -LogName Application -Source docker -Newest 50`
* For more information see the [Microsoft Troubleshooting guide](https://docs.microsoft.com/en-us/virtualization/windowscontainers/troubleshooting) and the [CleanupContainerHostNetworking](https://github.com/Microsoft/Virtualization-Documentation/tree/live/windows-server-container-tools/CleanupContainerHostNetworking) page.


# References

* [Using Insider Container Images](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/using-insider-container-images)
* [Beyond \ - the path to Windows and Linux parity in Docker (DockerCon 17)](https://www.youtube.com/watch?v=4ZY_4OeyJsw)
* [The Internals Behind Bringing Docker & Containers to Windows (DockerCon 16)](https://www.youtube.com/watch?v=85nCF5S8Qok)
* [Introducing the Host Compute Service](https://blogs.technet.microsoft.com/virtualization/2017/01/27/introducing-the-host-compute-service-hcs/)
