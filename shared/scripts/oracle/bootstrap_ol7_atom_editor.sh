#!/bin/sh -eux
# install atom text editor by github.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d")

# install atom editor. ---------------------------------------------------------
atomrepo="atom.x86_64.rpm"

# retrieve version number of latest release.
curl --silent --dump-header curl-atom.${curdate}.out1 https://github.com/atom/atom/releases/latest --output /dev/null
tr -d '\r' < curl-atom.${curdate}.out1 > curl-atom.${curdate}.out2
atomrelease=$(awk '/Location/ {print $2}' curl-atom.${curdate}.out2 | awk -F "/" '{print $8}')
rm -f curl-atom.${curdate}.out1
rm -f curl-atom.${curdate}.out2

# download atom repository from github.com.
wget --no-verbose https://github.com/atom/atom/releases/download/${atomrelease}/${atomrepo}
yum repolist
yum -y install ${atomrepo}

# verify installation.
#atom --version
#runuser -c "atom --version" - vagrant

# install atom markdown plugins.
#runuser -c "apm install tool-bar" - vagrant
#runuser -c "apm install markdown-writer" - vagrant
#runuser -c "apm install tool-bar-markdown-writer" - vagrant
#runuser -c "apm install markdown-scroll-sync" - vagrant
#runuser -c "apm install markdown-format" - vagrant

# install atom launcher on user desktop.
echo "Installing atom.desktop on user desktop..."
mkdir -p /home/vagrant/Desktop
cd /home/vagrant/Desktop
cp -f /usr/share/applications/atom.desktop .

chown -R vagrant:vagrant .
chmod 755 ./atom.desktop
