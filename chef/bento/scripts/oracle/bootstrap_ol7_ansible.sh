#!/bin/sh -eux
# install ansible on oracle linux 7.x.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# install the epel repository. -------------------------------------------------
wget --no-verbose https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum repolist
yum -y install epel-release-latest-7.noarch.rpm

# install ansible. -------------------------------------------------------------
yum -y install ansible

# verify ansible installation. -------------------------------------------------
ansible --version

# upgrade ansible installation. ------------------------------------------------
yum-config-manager --enable epel-testing
yum -y upgrade ansible

# verify ansible upgrade installation. -----------------------------------------
ansible --version
