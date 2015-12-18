Vagrant.configure("2") do |config|
  config.vm.box = "fedora/23-cloud-base"

  #config.vbguest.auto_update = false
  config.ssh.forward_x11 = true

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
  end

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = 2048
    vb.gui = true
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    vb.customize ["modifyvm", :id, "--vram", "64"]
    #vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
  end

  config.vm.provider "libvirt" do |libvirt|
    libvirt.driver = "kvm"
    libvirt.memory = 2048
    libvirt.cpus = 2
  end

  config.vm.provision "shell" do |s|
    s.inline = <<-SHELL
if [[ $(df --output=size -m /dev/vda1 | grep -o '[0-9]\\{2,\\}') -lt 5000 ]]; then
  echo "Increase disk space"
  growpart /dev/vda 1 && resize2fs /dev/vda1
fi
dnf install -q -y python2 python2-dnf libselinux-python
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/vagrant-nopasswd
SHELL
  end

  config.vm.provision "ansible" do |ansible|
    ansible.sudo = true
    #ansible.verbose = "vvvv"
    #ansible.skip_tags = [ "fedora-base", "fedora-gui", "tex", "eclipse" ]
    #ansible.start_at_task = "ensure alsa software is installed"
    #ansible.start_at_task = "ensure ruby header files are installed"
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
    vmconfig.vm.network :private_network, ip: "192.168.111.90"
    vmconfig.vm.hostname = 'workstation.test'
  end

  config.vm.define "mediacenter" do |vmconfig|
    vmconfig.vm.network :private_network, ip: "192.168.111.11"
    vmconfig.vm.hostname = 'mediacenter.test'

    if Vagrant.has_plugin?("vagrant-hostmanager")
      vmconfig.hostmanager.aliases = %w(mythweb.mediacenter.test cloud.mediacenter.test)
    end

    vmconfig.vm.provider "virtualbox" do |vb|
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
