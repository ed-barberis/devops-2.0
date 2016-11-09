#!/bin/bash
# create default environment profiles for devops users.
echo ""
echo ""

# create default environment profile for user 'root'. --------------------------
echo "-----------------------------------------------------------"
echo "Creating default environment profile for user 'root'..."
echo "-----------------------------------------------------------"
echo "Saving original files..."
cd /root
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

echo "Copying the new environment files..."
cp -f /vagrant/scripts/user-root-bash_profile.sh ./.bash_profile
cp -f /vagrant/scripts/user-root-bashrc.sh ./.bashrc

if [ -n "${http_proxy}" ]; then
  echo "Adding HTTP proxy variables..."
  sed -i 's/#http_proxy/http_proxy/g' .bashrc
  sed -i 's/#export http_proxy/export http_proxy/g' .bashrc
  sed -i 's/#https_proxy/https_proxy/g' .bashrc
  sed -i 's/#export https_proxy/export https_proxy/g' .bashrc
fi

echo "Copying VIM resource configuration files..."
cp -f /vagrant/scripts/vim-files.tar.gz .
tar -zxvf /vagrant/scripts/vim-files.tar.gz
rm -f vim-files.tar.gz

echo "Changing file ownership and permissions..."
chown -R root:root .
chmod 644 .bash_profile .bashrc
echo "-----------------------------------------------------------"
echo ""
echo ""

# create default environment profile for user 'vagrant'. -----------------------
echo "-----------------------------------------------------------"
echo "Creating default environment profile for user 'vagrant'..."
echo "-----------------------------------------------------------"
echo "Saving original files..."
cd /home/vagrant
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

echo "Copying the new environment files..."
cp -f /vagrant/scripts/user-vagrant-bash_profile.sh ./.bash_profile
cp -f /vagrant/scripts/user-vagrant-bashrc.sh ./.bashrc

if [ -n "${http_proxy}" ]; then
  echo "Adding HTTP proxy variables..."
  sed -i 's/#http_proxy/http_proxy/g' .bashrc
  sed -i 's/#export http_proxy/export http_proxy/g' .bashrc
  sed -i 's/#https_proxy/https_proxy/g' .bashrc
  sed -i 's/#export https_proxy/export https_proxy/g' .bashrc
fi

echo "Copying VIM resource configuration files..."
cp -f /vagrant/scripts/vim-files.tar.gz .
tar -zxvf /vagrant/scripts/vim-files.tar.gz
rm -f vim-files.tar.gz

echo "Changing file ownership and permissions..."
chown -R vagrant:vagrant .
chmod 644 .bash_profile .bashrc
echo "-----------------------------------------------------------"
echo ""
echo ""

# configure gnome desktop properties for devops users. ----------------------------
echo "Calling GNOME-3 desktop properties configuration script..."
runuser -c "/vagrant/scripts/config_ol7_gnome_desktop.sh" - vagrant
