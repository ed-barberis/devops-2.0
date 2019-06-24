#!/bin/sh -eux
# install ansible on centos linux 7.x.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# create scripts directory (if needed). ------------------------------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# install ansible. ---------------------------------------------------------------------------------
ansible_release="2.8.1-1"
ansible_binary="ansible-${ansible_release}.el7.ans.noarch.rpm"

# download ansible repository.
rm -f ${ansible_binary}
wget --no-verbose https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/${ansible_binary}

# install ansible. ---------------------------------------------------------------------------------
yum -y install ${ansible_binary}

# verify ansible installation.
ansible --version
