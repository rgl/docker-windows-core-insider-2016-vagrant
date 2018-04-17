This is a Docker on Windows Server 1803 Insider Vagrant environment for playing with Windows containers.

**THIS BRANCH WILL BE REBASED ON master FROM TIME TO TIME**

## Docker images

This environment builds and uses the following images:

```
REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
busybox-info                   latest              ea62c8418538        10 seconds ago      229MB
go-info                        latest              8d0a9bb86203        22 seconds ago      231MB
csharp-info                    latest              0387836b21ad        45 seconds ago      296MB
powershell-info                latest              fdb698ea4640        3 minutes ago       365MB
batch-info                     latest              f0db0237a922        4 minutes ago       228MB
portainer                      latest              3a95f6c5ec21        4 minutes ago       264MB
busybox                        latest              2d64d002a431        4 minutes ago       229MB
golang                         1.10                9b0720dab303        5 minutes ago       727MB
dotnet-sdk                     2.1.101             fccfb9070bbe        8 minutes ago       679MB
dotnet-runtime                 2.0.6               2144f92ba790        9 minutes ago       296MB
powershell                     6.0.2               924d5eb5bff5        10 minutes ago      361MB
microsoft/nanoserver-insider   10.0.17623.1002     43eb1f380ab7        3 days ago          228MB
```


# Usage

Install the [Base Windows Server Core Insider Box](https://github.com/rgl/windows-2016-vagrant).

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
vagrant execute -c '/vagrant/ps.ps1 examples/graceful-terminating-console-application/run.ps1'
vagrant execute -c '/vagrant/ps.ps1 examples/graceful-terminating-gui-application/run.ps1'
vagrant execute -c '/vagrant/ps.ps1 examples/graceful-terminating-windows-service/run.ps1'
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
