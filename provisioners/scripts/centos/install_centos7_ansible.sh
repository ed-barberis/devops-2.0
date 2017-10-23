#!/bin/sh -eux
# install ansible on centos linux 7.x.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/centos
cd /tmp/scripts/centos

# install ansible. -------------------------------------------------------------
ansible_release="2.4.0.0-1"
#ansible_release="2.3.2.0-1"
ansible_binary="ansible-${ansible_release}.el7.ans.noarch.rpm"

# download ansible repository.
wget --no-verbose http://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/${ansible_binary}

# install ansible. -------------------------------------------------------------
yum repolist
yum -y install ${ansible_binary}

# verify ansible installation.
ansible --version

# install ansible container. ---------------------------------------------------
# install latest from repository.
pip install ansible-container

# verify installation.
ansible-container version

# build and install latest ansible container binaries from source. -------------
# create ansible container source parent folder.
#mkdir -p /usr/local/src/ansible
#cd /usr/local/src/ansible

# download ansible container source from github.com.
#git clone https://github.com/ansible/ansible-container.git ansible-container
#wget --no-verbose https://github.com/ansible/ansible-container/archive/release-0.9.0.tar.gz

# build and install ansible container binaries.
#cd ansible-container
#python ./setup.py install

# verify installation.
#ansible-container version
