# My Ansible configuration #

With these files I set up my computers.

## Configuration

Before you start, you have to create the file `vars.yml` in the root directory. It contains some private configuration.
You can copy the file `vars.dist.yml` to start with.

## Vagrant

For testing there is a Vagrantfile to install in Vagrant boxes.

## Without Vagrant

You have to install Ansible first. This is for Fedora:

    yum -y install ansible

Configure the groups of hosts in the file `production` (see /etc/ansible/hosts for an example).

Then run ansible:

    ansible-playbook -i production -l [group] site.yml
