#!/bin/sh -eux
# install chrome browser for linux by google.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/centos
cd /tmp/scripts/centos

# install the adobe flash plug-in. ---------------------------------------------
#wget --no-verbose http://linuxdownload.adobe.com/linux/x86_64/adobe-release-x86_64-1.0-1.noarch.rpm
yum repolist
#yum -y install adobe-release-x86_64-1.0-1.noarch.rpm
yum -y install ./tools/adobe-release-x86_64-1.0-1.noarch.rpm
yum -y install flash-plugin

# install google chrome browser. -----------------------------------------------
wget --no-verbose https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum -y install google-chrome-stable_current_x86_64.rpm

# install linux chrome launcher on user desktop.
#echo "Installing google-chrome.desktop on user desktop..."
#mkdir -p /home/vagrant/Desktop
#cd /home/vagrant/Desktop
#cp -f /usr/share/applications/google-chrome.desktop .

#chown -R vagrant:vagrant .
#chmod 755 ./google-chrome.desktop
