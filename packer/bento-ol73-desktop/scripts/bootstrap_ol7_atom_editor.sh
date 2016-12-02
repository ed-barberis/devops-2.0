#!/bin/sh -eux
# install atom text editor by github.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# install atom editor 1.12.6. --------------------------------------------------
atomrelease="v1.12.6"
#atomrelease="v1.13.0-beta6"

# download atom repository from github.com.
wget --no-verbose https://github.com/atom/atom/releases/download/${atomrelease}/atom.x86_64.rpm
rpm -Uvh atom.x86_64.rpm
yum repolist
yum -y install atom

# verify installation.
#atom --version

# install atom markdown plugins.
#runuser -c "apm install tool-bar" - vagrant
#runuser -c "apm install markdown-writer" - vagrant
#runuser -c "apm install tool-bar-markdown-writer" - vagrant
#runuser -c "apm install markdown-scroll-sync" - vagrant
#runuser -c "apm install markdown-format" - vagrant
