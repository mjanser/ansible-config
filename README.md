# My Ansible configuration #

With these files I set up my computers.

## Configuration

Before you start, you have to create the file `vars.yml` in the `group_vars/all` directory. It contains some private configuration.
You can copy the file `vars.dist.yml` to start with.

## Vagrant

For testing there is a Vagrantfile to install in Vagrant boxes.

## Without Vagrant

You have to install Ansible and some other packages first. This is for Fedora:

    dnf -y install ansible python2-dnf libselinux-python

Configure the groups of hosts in the file `production` (see /etc/ansible/hosts for an example).
Install the dependencies from Ansible Galaxy:

    ansible-galaxy install -r requirements.yml -p roles-galaxy

Then run ansible:

    ansible-playbook -i production -l [group] site.yml

To run it with sudo, use:

    ansible-playbook -i production -l [group] --sudo --ask-sudo-pass site.yml
