#!/bin/sh -eux
# install chrome browser for linux by google.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# install the adobe flash plug-in. ---------------------------------------------
wget --no-verbose http://linuxdownload.adobe.com/linux/x86_64/adobe-release-x86_64-1.0-1.noarch.rpm
yum repolist
yum -y install adobe-release-x86_64-1.0-1.noarch.rpm
yum -y install flash-plugin

# install google chrome browser. -----------------------------------------------
wget --no-verbose https://chrome.richardlloyd.org.uk/install_chrome.sh
chmod 755 install_chrome.sh
./install_chrome.sh -f

# install linux chrome launcher on user desktop.
#echo "Installing google-chrome.desktop on user desktop..."
#mkdir -p /home/vagrant/Desktop
#cd /home/vagrant/Desktop
#cp -f /usr/share/applications/google-chrome.desktop .

#chown -R vagrant:vagrant .
#chmod 755 ./google-chrome.desktop
