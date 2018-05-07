#!/bin/sh -eux
# install ansible container on centos linux 7.x.

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
