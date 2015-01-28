# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vbguest.auto_update = false
  config.ssh.forward_x11 = true

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "60"]
  end

  config.vm.provision "shell",
    inline: "rm -f /etc/systemd/system/firewalld.service && systemctl daemon-reload"

  config.vm.provision "ansible" do |ansible|
    ansible.sudo = true
    #ansible.verbose = "vvvv"
    ansible.skip_tags = [ "fedora-base", "fedora-gui", "tex", "eclipse" ]
    ansible.playbook = "site.yml"
    ansible.groups = {
      "workstations" => ["workstation"],
      "mediacenters" => ["mediacenter"],
    }
  end

  config.vm.define "workstation" do |vmconfig|
    vmconfig.vm.box = "TFDuesing/Fedora-21"
    vmconfig.vm.network :private_network, ip: "192.168.222.10"
    vmconfig.vm.hostname = 'workstation.test'

    vmconfig.vm.provider "virtualbox" do |vb|
      vb.cpus = 2
      vb.memory = 2048
      vb.customize ["modifyvm", :id, "--vram", "64"]
    end
  end

  config.vm.define "mediacenter" do |vmconfig|
    vmconfig.vm.box = "TFDuesing/Fedora-21"
    vmconfig.vm.network :private_network, ip: "192.168.222.11"
    vmconfig.vm.hostname = 'mediacenter.test'

    vmconfig.vm.synced_folder "data/backup", "/var/lib/backup", type: "rsync",
        rsync__chown: false,
        rsync__exclude: ".gitkeep",
        rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "--delete", "-z"]
  end
end
