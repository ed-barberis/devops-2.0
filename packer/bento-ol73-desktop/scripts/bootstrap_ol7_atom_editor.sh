#!/bin/sh -eux
# install atom text editor by github.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d")

# install atom editor. ---------------------------------------------------------
# retrieve version number of latest release.
wget --no-verbose --server-response https://github.com/atom/atom/releases/latest >| wget-atom.${curdate}.out 2>&1
atomrelease=$(awk '/Location/ {print $2}' wget-atom.${curdate}.out | awk -F "/" '{print $8}')
rm -f wget-atom.${curdate}.out

# download atom repository from github.com.
wget --no-verbose https://github.com/atom/atom/releases/download/${atomrelease}/atom.x86_64.rpm
yum repolist
yum -y install atom.x86_64.rpm

# verify installation.
#atom --version

# install atom markdown plugins.
#runuser -c "apm install tool-bar" - vagrant
#runuser -c "apm install markdown-writer" - vagrant
#runuser -c "apm install tool-bar-markdown-writer" - vagrant
#runuser -c "apm install markdown-scroll-sync" - vagrant
#runuser -c "apm install markdown-format" - vagrant
