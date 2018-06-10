This is a Docker on Windows Server 1803 Insider Vagrant environment for playing with Windows containers.

**THIS BRANCH WILL BE REBASED ON master FROM TIME TO TIME**

## Docker images

This environment builds and uses the following images:

```
REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
busybox-info                   latest              0c5dd6ddde89        10 seconds ago      233MB
go-info                        latest              285927bf427f        21 seconds ago      235MB
csharp-info                    latest              5e99c1c63b9e        42 seconds ago      305MB
powershell-info                latest              797e108d4813        3 minutes ago       369MB
batch-info                     latest              b830ad35563b        4 minutes ago       233MB
portainer                      latest              e224ea5d2ed2        4 minutes ago       270MB
busybox                        latest              7b6aee9749cd        5 minutes ago       233MB
golang                         1.10.3              11a69e467f3b        5 minutes ago       731MB
dotnet-sdk                     2.1.300             d0861b177f39        8 minutes ago       682MB
dotnet-runtime                 2.1.0               9210d5567632        9 minutes ago       305MB
powershell                     6.0.2               24994b8ee6db        9 minutes ago       365MB
microsoft/nanoserver-insider   10.0.17677.1000     318910c6fbca        2 weeks ago         232MB
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
