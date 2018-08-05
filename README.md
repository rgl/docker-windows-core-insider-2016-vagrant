This is a Docker on Windows Server 1803 Insider Vagrant environment for playing with Windows containers.

**THIS BRANCH WILL BE REBASED ON master FROM TIME TO TIME**

## Docker images

This environment builds and uses the following images:

```
REPOSITORY                                    TAG                 IMAGE ID            CREATED             SIZE
busybox-info                                  latest              e6aa0140876d        10 seconds ago      238MB
go-info                                       latest              186545fae747        22 seconds ago      240MB
csharp-info                                   latest              eae004315158        48 seconds ago      309MB
powershell-info                               latest              9b8fafc02729        4 minutes ago       375MB
batch-info                                    latest              bdb58b8b5c35        5 minutes ago       237MB
portainer                                     1.18.1              1d26f586dc37        5 minutes ago       279MB
busybox                                       latest              37e695e25794        5 minutes ago       238MB
golang                                        1.10.3              fce9e17bb816        6 minutes ago       737MB
dotnet-sdk                                    2.1.302             8bc9ebf081db        9 minutes ago       685MB
dotnet-runtime                                2.1.2               fe399e89826a        10 minutes ago      309MB
powershell                                    6.0.3               166753ab51b7        11 minutes ago      371MB
mcr.microsoft.com/nanoserver-insider          10.0.17723.1000     837e451a7d06        10 days ago         237MB
mcr.microsoft.com/windowsservercore-insider   10.0.17723.1000     f13c6a79c357        10 days ago         3.43GB
mcr.microsoft.com/windows-insider             10.0.17723.1000     9a084b9c5e03        10 days ago         8.17GB
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
