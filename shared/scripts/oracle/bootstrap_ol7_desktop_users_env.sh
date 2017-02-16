#!/bin/sh -eux
# create default desktop environment profiles for devops users.

# create default environment profile for user 'root'. --------------------------
cd /root
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f /tmp/scripts/oracle/users/user-root-bash_profile.sh ./.bash_profile
cp -f /tmp/scripts/oracle/users/user-root-bashrc.sh ./.bashrc

if [ -n "${http_proxy}" ]; then
  sed -i 's/#http_proxy/http_proxy/g' .bashrc
  sed -i 's/#export http_proxy/export http_proxy/g' .bashrc
  sed -i 's/#https_proxy/https_proxy/g' .bashrc
  sed -i 's/#export https_proxy/export https_proxy/g' .bashrc
fi

cp -f /tmp/scripts/oracle/tools/vim-files.tar.gz .
tar -zxvf vim-files.tar.gz --no-same-owner --no-overwrite-dir
rm -f vim-files.tar.gz

chown -R root:root .
chmod 644 .bash_profile .bashrc

# create default environment profile for user 'vagrant'. -----------------------
cd /home/vagrant
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f /tmp/scripts/oracle/users/user-vagrant-bash_profile.sh ./.bash_profile
cp -f /tmp/scripts/oracle/users/user-vagrant-bashrc.sh ./.bashrc

if [ -n "${http_proxy}" ]; then
  sed -i 's/#http_proxy/http_proxy/g' .bashrc
  sed -i 's/#export http_proxy/export http_proxy/g' .bashrc
  sed -i 's/#https_proxy/https_proxy/g' .bashrc
  sed -i 's/#export https_proxy/export https_proxy/g' .bashrc
fi

cp -f /tmp/scripts/oracle/tools/vim-files.tar.gz .
tar -zxvf vim-files.tar.gz --no-same-owner --no-overwrite-dir
rm -f vim-files.tar.gz

chown -R vagrant:vagrant .
chmod 644 .bash_profile .bashrc

# configure gnome-3 desktop properties for devops users. --------------------------
echo ""
cd /tmp/scripts/oracle
pwd
echo ""
ls -alF
echo ""
chmod 755 config_ol7_gnome_desktop.sh
runuser -c "/tmp/scripts/oracle/config_ol7_gnome_desktop.sh" - vagrant
