#!/bin/sh -eux
# install atom text editor by github.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# install atom editor 1.11.2. --------------------------------------------------
atomrelease="v1.11.2"
#atomrelease="v1.12.0-beta5"

# download atom repository from github.com.
wget --no-verbose https://github.com/atom/atom/releases/download/${atomrelease}/atom.x86_64.rpm
rpm -Uvh atom.x86_64.rpm
yum repolist
yum -y install atom

# verify installation.
#atom --version
