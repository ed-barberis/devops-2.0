#!/bin/sh -eux
# create default headless (command-line) environment profiles for devops users.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# create default environment profile for user 'root'. ----------------------------------------------
root_profile="${devops_home}/provisioners/scripts/common/users/user-root-bash_profile.sh"
root_rc="${devops_home}/provisioners/scripts/common/users/user-root-bashrc.sh"

# uncomment proxy environment variables (if set).
proxy_set="${http_proxy:-}"
if [ -n "${proxy_set}" ]; then
  sed -i 's/^#http_proxy/http_proxy/g;s/^#export http_proxy/export http_proxy/g' ${root_rc}
  sed -i 's/^#https_proxy/https_proxy/g;s/^#export https_proxy/export https_proxy/g' ${root_rc}
fi

# copy environment profiles to user 'root' home.
cd /root
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f ${root_profile} .bash_profile
cp -f ${root_rc} .bashrc

# remove existing vim profile if it exists.
if [ -d ".vim" ]; then
  rm -Rf ./.vim
fi

cp -f ${devops_home}/provisioners/scripts/common/tools/vim-files.tar.gz .
tar -zxvf vim-files.tar.gz --no-same-owner --no-overwrite-dir
rm -f vim-files.tar.gz

chown -R root:root .
chmod 644 .bash_profile .bashrc

# create default environment profile for user 'vagrant'. -------------------------------------------
vagrant_profile="${devops_home}/provisioners/scripts/common/users/user-vagrant-bash_profile.sh"
vagrant_rc="${devops_home}/provisioners/scripts/common/users/user-vagrant-bashrc.sh"

# uncomment proxy environment variables (if set).
proxy_set="${http_proxy:-}"
if [ -n "${proxy_set}" ]; then
  sed -i 's/^#http_proxy/http_proxy/g;s/^#export http_proxy/export http_proxy/g' ${vagrant_rc}
  sed -i 's/^#https_proxy/https_proxy/g;s/^#export https_proxy/export https_proxy/g' ${vagrant_rc}
fi

# copy environment profiles to user 'vagrant' home.
cd /home/vagrant
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f ${vagrant_profile} .bash_profile
cp -f ${vagrant_rc} .bashrc

# remove existing vim profile if it exists.
if [ -d ".vim" ]; then
  rm -Rf ./.vim
fi

cp -f ${devops_home}/provisioners/scripts/common/tools/vim-files.tar.gz .
tar -zxvf vim-files.tar.gz --no-same-owner --no-overwrite-dir
rm -f vim-files.tar.gz

chown -R vagrant:vagrant .
chmod 644 .bash_profile .bashrc

# create docker profile for the user. --------------------------------------------------------------
# add user 'vagrant' to the 'docker' group.
usermod -aG docker vagrant

# install docker completion for bash.
dcompletion_release="18.09.0"
dcompletion_binary=".docker-completion.sh"
userfolder="/home/vagrant"

# download docker completion for bash from github.com.
rm -f ${userfolder}/${dcompletion_binary}
curl --silent --location "https://github.com/docker/cli/raw/v${dcompletion_release}/contrib/completion/bash/docker" --output ${userfolder}/${dcompletion_binary}
chown -R vagrant:vagrant ${userfolder}/${dcompletion_binary}
chmod 644 ${userfolder}/${dcompletion_binary}

# install docker compose completion for bash.
dcrelease="1.23.2"
dccompletion_binary=".docker-compose-completion.sh"

# download docker completion for bash from github.com.
rm -f ${userfolder}/${dccompletion_binary}
curl --silent --location "https://github.com/docker/compose/raw/${dcrelease}/contrib/completion/bash/docker-compose" --output ${userfolder}/${dccompletion_binary}
chown -R vagrant:vagrant ${userfolder}/${dccompletion_binary}
chmod 644 ${userfolder}/${dccompletion_binary}
