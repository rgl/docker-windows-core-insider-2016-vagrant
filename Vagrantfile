Vagrant.configure("2") do |config|
  config.vm.box = "windows-2019-amd64"

  config.vm.provider "libvirt" do |lv, config|
    lv.memory = 5*1024
    lv.cpus = 2
    lv.cpu_mode = "host-passthrough"
    lv.nested = true
    lv.keymap = "pt"
    # replace the default synced_folder with something that works in the base box.
    # NB for some reason, this does not work when placed in the base box Vagrantfile.
    config.vm.synced_folder ".", "/vagrant", type: "smb", smb_username: ENV["USER"], smb_password: ENV["VAGRANT_SMB_PASSWORD"]
  end

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.memory = 5*1024
    vb.cpus = 2
  end

  config.vm.network "private_network", ip: "10.0.0.3", libvirt__forward_mode: "route", libvirt__dhcp_enabled: false

  config.vm.provision "shell", path: "ps.ps1", args: "provision-hyper-v-feature.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-containers-feature.ps1"
  config.vm.provision "reload"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-chocolatey.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-base.ps1"
  # NB admin-center seems to re-configure the network and drop the vagrant network connection...
  #    which makes the vagrant up fail, so until a solution is found, this is disabled.
  #config.vm.provision "shell", path: "ps.ps1", args: "provision-admin-center.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-docker.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "provision-docker-reg.ps1"
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
  config.vm.provision "shell", path: "ps.ps1", args: "examples/graceful-terminating-console-application/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/graceful-terminating-windows-service/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "examples/graceful-terminating-gui-application/run.ps1"
  config.vm.provision "shell", path: "ps.ps1", args: "summary.ps1"
end
