#!/bin/sh -eux
# create default headless (command-line) environment profile for devops 'root' user.

# set default values for input environment variables if not set. -----------------------------------
user_name="root"                                                # user name for 'root' user.
user_group="root"                                               # user login group for 'root' user.
user_home="/root"                                               # user home for 'root' user.
user_prompt_color="red"                                         # user prompt color (defaults to 'red').
                                                                #   valid colors:
                                                                #     'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                       # [optional] devops home (defaults to '/opt/devops').

# create default environment profile for the user. -------------------------------------------------
root_bashprofile="${devops_home}/provisioners/scripts/common/users/user-root-bash_profile.sh"
root_bashrc="${devops_home}/provisioners/scripts/common/users/user-root-bashrc.sh"

# uncomment proxy environment variables (if set).
proxy_set="${http_proxy:-}"
if [ -n "${proxy_set}" ]; then
  sed -i 's/^#http_proxy/http_proxy/g;s/^#export http_proxy/export http_proxy/g' ${root_bashrc}
  sed -i 's/^#https_proxy/https_proxy/g;s/^#export https_proxy/export https_proxy/g' ${root_bashrc}
fi

# set user prompt color.
sed -i "s/{red}/{${user_prompt_color}}/g" ${root_bashrc}

# copy environment profiles to user home.
cd ${user_home}
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

chown -R ${user_name}:${user_group} .
chmod 644 .bash_profile .bashrc
