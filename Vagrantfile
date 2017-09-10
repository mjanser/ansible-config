Vagrant.configure('2') do |config|
  config.vm.box = 'fedora/25-cloud-base'

  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = false
    config.hostmanager.ignore_private_ip = false
  end

  config.vm.provider 'libvirt' do |libvirt|
    libvirt.driver = 'kvm'
  end

  config.vm.provision 'shell' do |s|
    s.inline = <<-SHELL
if [ "mediacenter.test" = "$HOSTNAME" -o "workstation.test" = "$HOSTNAME" ]; then
  if [[ $(df --output=size -m /dev/vda1 | grep -o '[0-9]\\{2,\\}') -lt 5000 ]]; then
    echo "Increase disk space"
    growpart /dev/vda 1 && resize2fs /dev/vda1
  fi
  dnf install -q -y python2 python2-dnf libselinux-python
  echo "vagrant ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/vagrant-nopasswd
elif [ "router.test" = "$HOSTNAME" ]; then
  opkg update
  opkg install python-light python-logging python-openssl python-codecs python-distutils openvpn-openssl
fi
SHELL
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.sudo = true
    ansible.galaxy_role_file = 'requirements.yml'
    ansible.galaxy_roles_path = 'roles-galaxy'
    ansible.playbook = 'site.yml'
    ansible.groups = {
      'workstations' => ['workstation'],
      'mediacenters' => ['mediacenter'],
      'cloud' => ['cloud'],
      'routers' => ['router'],
    }
    ansible.extra_vars = {
      local_network: '192.168.222.0/24',
      router_lan_interfaces: 'eth1',
      router_wan_interfaces: 'eth0',
      mpd_outputs: [
        {
          'name' => 'Default',
          'type' => 'alsa',
          'device' => 'hw:0,0',
        }
      ],
      pulseaudio_sink_formats: [],
      cloud_server_name: 'cloud.mediacenter.test'
    }
  end

  config.vm.define 'workstation' do |vmconfig|
    vmconfig.vm.network :private_network, ip: '192.168.111.90'
    vmconfig.vm.hostname = 'workstation.test'
    vmconfig.ssh.forward_x11 = true

    config.vm.provider 'libvirt' do |libvirt|
      libvirt.memory = 2048
      libvirt.cpus = 2
    end
  end

  config.vm.define 'mediacenter' do |vmconfig|
    vmconfig.vm.network :private_network, ip: '192.168.111.11'
    vmconfig.vm.hostname = 'mediacenter.test'
    vmconfig.ssh.forward_x11 = true

    config.vm.provider 'libvirt' do |libvirt|
      libvirt.memory = 2048
      libvirt.cpus = 2
    end

    if Vagrant.has_plugin?('vagrant-hostmanager')
      vmconfig.hostmanager.aliases = %w(mythweb.mediacenter.test, cockpit.mediacenter.test)
    end

    vmconfig.vm.synced_folder 'data/backup', '/var/lib/backup', type: 'rsync', rsync__chown: false, rsync__exclude: '.gitignore'
  end

  config.vm.define 'cloud' do |vmconfig|
    vmconfig.vm.box = 'debian/stretch64'
    vmconfig.vm.hostname = 'cloud.test'
    vmconfig.vm.network 'forwarded_port', guest: 443, host: 8888
  end

  config.vm.define 'router' do |vmconfig|
    vmconfig.vm.box = 'rudineirk/openwrt-15.05'
    vmconfig.vm.network :private_network, ip: '192.168.111.2'
    vmconfig.vm.hostname = 'router.test'

    vmconfig.vm.synced_folder '.', '/vagrant', disabled: true

    vmconfig.vm.provider 'libvirt' do |libvirt|
      libvirt.driver = 'kvm'
      libvirt.memory = 1024
      libvirt.cpus = 1
    end
  end
end
