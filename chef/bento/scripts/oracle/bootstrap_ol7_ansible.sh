#!/bin/sh -eux
# install ansible on oracle linux 7.x.

# install epel repository if needed. -------------------------------------------
epel_repo="/etc/yum.repos.d/epel.repo"
if [ ! -f "$epel_repo" ]; then
  # create temporary scripts directory.
  mkdir -p /tmp/scripts/oracle
  cd /tmp/scripts/oracle

  # install the epel repository.
  wget --no-verbose https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  yum repolist
  yum -y install epel-release-latest-7.noarch.rpm
fi

# install ansible. -------------------------------------------------------------
yum -y install ansible

# verify ansible installation. -------------------------------------------------
ansible --version

# upgrade ansible installation. ------------------------------------------------
yum-config-manager --enable epel-testing
yum -y upgrade ansible

# verify ansible upgrade installation. -----------------------------------------
ansible --version
