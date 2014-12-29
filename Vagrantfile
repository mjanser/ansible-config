# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vbguest.auto_update = false
  config.ssh.forward_x11 = true

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = 2048
  end

  config.vm.provision "shell",
    inline: "rm -f /etc/systemd/system/firewalld.service && systemctl daemon-reload"

  config.vm.provision "ansible" do |ansible|
    ansible.sudo = true
    ansible.verbose = "vvvv"
    ansible.playbook = "site.yml"
    ansible.groups = {
      "workstations" => ["workstation"],
      "mediacenters" => ["mediacenter"],
    }
  end

  config.vm.define "workstation" do |vmconfig|
    vmconfig.vm.box = "TFDuesing/Fedora-21"
    vmconfig.vm.network :private_network, ip: "192.168.222.10"
    vmconfig.vm.hostname = 'workstation-test'
  end

  config.vm.define "mediacenter" do |vmconfig|
    vmconfig.vm.box = "TFDuesing/Fedora-21"
    vmconfig.vm.network :private_network, ip: "192.168.222.11"
    vmconfig.vm.hostname = 'mediacenter-test'
  end
end
