#!/bin/sh -eux
# create default headless (command-line) environment profiles for devops users.

# set default values for input environment variables if not set. -----------------------------------
user_name="${user_name:-vagrant}"                               # [optional] user name (defaults to 'vagrant').
user_group="${user_group:-vagrant}"                             # [optional] user login group (defaults to 'vagrant').
user_home="${user_home:-/home/$user_name}"                      # [optional] user home (defaults to '/home/vagrant').
user_docker_profile="${user_docker_profile:-false}"             # [optional] user docker profile (defaults to 'false').
user_prompt_color="${user_prompt_color:-green}"                 # [optional] user prompt color (defaults to 'green').
                                                                #            valid colors:
                                                                #              'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'
d_completion_release="${d_completion_release:-18.09.5}"         # [optional] docker completion for bash release (defaults to '18.09.5').
dc_completion_release="${dc_completion_release:-1.24.0}"        # [optional] docker compose completion for bash release (defaults to '1.24.0').

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                       # [optional] devops home (defaults to '/opt/devops').

# create default environment profile for user 'root'. ----------------------------------------------
root_bashprofile="${devops_home}/provisioners/scripts/common/users/user-root-bash_profile.sh"
root_bashrc="${devops_home}/provisioners/scripts/common/users/user-root-bashrc.sh"

# uncomment proxy environment variables (if set).
proxy_set="${http_proxy:-}"
if [ -n "${proxy_set}" ]; then
  sed -i 's/^#http_proxy/http_proxy/g;s/^#export http_proxy/export http_proxy/g' ${root_bashrc}
  sed -i 's/^#https_proxy/https_proxy/g;s/^#export https_proxy/export https_proxy/g' ${root_bashrc}
fi

# set user prompt color.
#sed -i "s/{red}/{${user_prompt_color}}/g" ${root_bashrc}

# copy environment profiles to user 'root' home.
cd /root
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f ${root_bashprofile} .bash_profile
cp -f ${root_bashrc} .bashrc

# remove existing vim profile if it exists.
if [ -d ".vim" ]; then
  rm -Rf ./.vim
fi

cp -f ${devops_home}/provisioners/scripts/common/tools/vim-files.tar.gz .
tar -zxvf vim-files.tar.gz --no-same-owner --no-overwrite-dir
rm -f vim-files.tar.gz

chown -R root:root .
chmod 644 .bash_profile .bashrc

# create default environment profile for the user. -------------------------------------------------
user_bashprofile="${devops_home}/provisioners/scripts/common/users/user-vagrant-bash_profile.sh"
user_bashrc="${devops_home}/provisioners/scripts/common/users/user-vagrant-bashrc.sh"

# uncomment proxy environment variables (if set).
proxy_set="${http_proxy:-}"
if [ -n "${proxy_set}" ]; then
  sed -i 's/^#http_proxy/http_proxy/g;s/^#export http_proxy/export http_proxy/g' ${user_bashrc}
  sed -i 's/^#https_proxy/https_proxy/g;s/^#export https_proxy/export https_proxy/g' ${user_bashrc}
fi

# set user prompt color.
sed -i "s/{green}/{${user_prompt_color}}/g" ${user_bashrc}

# copy environment profiles to user home.
cd ${user_home}
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f ${user_bashprofile} .bash_profile
cp -f ${user_bashrc} .bashrc

# remove existing vim profile if it exists.
if [ -d ".vim" ]; then
  rm -Rf ./.vim
fi

cp -f ${devops_home}/provisioners/scripts/common/tools/vim-files.tar.gz .
tar -zxvf vim-files.tar.gz --no-same-owner --no-overwrite-dir
rm -f vim-files.tar.gz

chown -R ${user_name}:${user_group} .
chmod 644 .bash_profile .bashrc

# create docker profile for the user. --------------------------------------------------------------
if [ "$user_docker_profile" == "true" ] && [ "$user_name" != "root" ]; then
  # add user to the 'docker' group.
  usermod -aG docker ${user_name}

  # install docker completion for bash.
  d_completion_binary=".docker-completion.sh"

  # download docker completion for bash from github.com.
  rm -f ${user_home}/${d_completion_binary}
  curl --silent --location "https://github.com/docker/cli/raw/v${d_completion_release}/contrib/completion/bash/docker" --output ${user_home}/${d_completion_binary}
  chown -R ${user_name}:${user_group} ${user_home}/${d_completion_binary}
  chmod 644 ${user_home}/${d_completion_binary}

  # install docker compose completion for bash.
  dc_completion_binary=".docker-compose-completion.sh"

  # download docker completion for bash from github.com.
  rm -f ${user_home}/${dc_completion_binary}
  curl --silent --location "https://github.com/docker/compose/raw/${dc_completion_release}/contrib/completion/bash/docker-compose" --output ${user_home}/${dc_completion_binary}
  chown -R ${user_name}:${user_group} ${user_home}/${dc_completion_binary}
  chmod 644 ${user_home}/${dc_completion_binary}
fi
