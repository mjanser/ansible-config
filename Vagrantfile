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

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
  end

  config.vm.provision "shell",
    inline: "rm -f /etc/systemd/system/firewalld.service && systemctl daemon-reload"

  config.vm.provision "ansible" do |ansible|
    ansible.sudo = true
    #ansible.verbose = "vvvv"
    #ansible.skip_tags = [ "fedora-base", "fedora-gui", "tex", "eclipse" ]
    #ansible.start_at_task = "ensure alsa software is installed"
    #ansible.start_at_task = "ensure kodi software is installed"
    ansible.playbook = "site.yml"
    ansible.groups = {
      "workstations" => ["workstation"],
      "mediacenters" => ["mediacenter"],
    }
    ansible.extra_vars = {
      local_network: "192.168.222.0/24",
      mpd_device: "hw:0,0",
      cloud_server_name: "cloud.mediacenter.test"
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

    if Vagrant.has_plugin?("vagrant-hostmanager")
      vmconfig.hostmanager.aliases = %w(mythweb.mediacenter.test cloud.mediacenter.test)
    end

    vmconfig.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.customize ["modifyvm", :id, "--audio", "alsa"]
    end

    vmconfig.vm.synced_folder "data/backup", "/var/lib/backup", type: "rsync",
        rsync__chown: false,
        rsync__exclude: ".gitignore",
        rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "-z"]

    vmconfig.vm.synced_folder "data/media", "/var/lib/media", type: "rsync",
        rsync__chown: false,
        rsync__exclude: ".gitignore",
        rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "-z"]
  end
end
