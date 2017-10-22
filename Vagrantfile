Vagrant.configure("2") do |config|
  config.vm.box = "windows-core-insider-2016-amd64"

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.memory = 2048
  end

  config.vm.network "private_network", ip: "10.0.0.3"

  config.vm.provision "shell", path: "ps.ps1", args: "provision-project-honolulu.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-chocolatey.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-base.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-containers-feature.ps1"
  config.vm.provision "reload"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-docker.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "images/powershell/build.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "images/dotnet-runtime/build.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "images/dotnet-sdk/build.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "images/golang/build.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "images/busybox/build.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "images/portainer/build.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "images/portainer/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/batch/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/powershell/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/csharp/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/go/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/sh/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "summary.ps1"
end
