# My Ansible configuration

With these files I set up my computers.

## Configuration

Before you start, you have to create the files `secrets.yml` in the directories `group_vars/all`, `group_vars/cloud`, `group_vars/home-control` and `group_vars/routers`.
It contains some private configuration. You can copy the corresponding `secrets.dist.yml` files to start with.

## Vagrant

For testing there is a Vagrantfile which runs the installation in virtual machines.

## Without Vagrant

You have to install Ansible and some other packages first. This is for Fedora:

    dnf -y install ansible python2-dnf libselinux-python

Configure the groups of hosts in the file `production` (see /etc/ansible/hosts for an example).
Install the dependencies from Ansible Galaxy:

    ansible-galaxy install -r requirements.yml -p roles-galaxy

Then run ansible:

    ansible-playbook -i production -l [group] site.yml

To run it with sudo, use:

    ansible-playbook -i production -l [group] --become site.yml
