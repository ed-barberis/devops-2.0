#!/bin/sh -eux
# install ansible on oracle linux 7.x.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# install epel repository if needed. -------------------------------------------
if [ ! -f "/etc/yum.repos.d/epel.repo" ]; then
  wget --no-verbose https://download.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  yum repolist
  yum -y install epel-release-latest-7.noarch.rpm
fi

# install ansible. -------------------------------------------------------------
yum -y install ansible

# verify ansible installation.
ansible --version

# upgrade ansible installation. ------------------------------------------------
#yum-config-manager --enable epel-testing
#yum -y upgrade ansible

# verify ansible upgrade installation.
#ansible --version

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
