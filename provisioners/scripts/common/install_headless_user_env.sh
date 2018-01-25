#!/bin/sh -eux
# create default headless (command-line) environment profile for devops user.

# set default values for input environment variables if not set. ---------------
user_name="${user_name:-}"                                  # user name.
user_group="${user_group:-}"                                # user login group.
user_home="${user_home:-/home/$user_name}"                  # [optional] user home (defaults to '/home/user_name').
user_prompt_color="${user_prompt_color:-green}"             # [optional] user prompt color (defaults to 'green').
                                                            #            valid colors are:
                                                            #              'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'

# define usage function. -------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with correct privilege for the given user name.
  Example:
    [root]# export user_name="user1"                        # user name.
    [root]# export user_group="group1"                      # user login group.
    [root]# export user_home="/home/user1"                  # [optional] user home (defaults to '/home/user_name').
    [root]# export user_prompt_color="yellow"               # [optional] user prompt color (defaults to 'green').
                                                            #            valid colors:
                                                            #              'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'
    [root]# $0
EOF
}

# validate environment variables. ----------------------------------------------
if [ -z "$user_name" ]; then
  echo "Error: 'user_name' environment variable not set."
  usage
  exit 1
fi

if [ -z "$user_group" ]; then
  echo "Error: 'user_group' environment variable not set."
  usage
  exit 1
fi

if [ ! -z "$user_prompt_color" ]; then
  case $user_prompt_color in
      black|blue|cyan|green|magenta|red|white|yellow)
        ;;
      *)
        echo "Error: invalid 'user_prompt_color'."
        usage
        exit 1
        ;;
  esac
fi

# create default environment profile for the user. -----------------------------
if [ "$user_name" == "root" ]; then
  master_bashprofile="/tmp/scripts/common/users/user-root-bash_profile.sh"
  master_bashrc="/tmp/scripts/common/users/user-root-bashrc.sh"
  user_home="/root"                                         # override user home for 'root' user.
else
  master_bashprofile="/tmp/scripts/common/users/user-vagrant-bash_profile.sh"
  master_bashrc="/tmp/scripts/common/users/user-vagrant-bashrc.sh"
fi

# copy environment profiles to user home.
cd ${user_home}
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f ${master_bashprofile} .bash_profile
cp -f ${master_bashrc} .bashrc

# uncomment proxy environment variables (if set).
proxy_set="${http_proxy:-}"
if [ -n "${proxy_set}" ]; then
  sed -i 's/^#http_proxy/http_proxy/g;s/^#export http_proxy/export http_proxy/g' .bashrc
  sed -i 's/^#https_proxy/https_proxy/g;s/^#export https_proxy/export https_proxy/g' .bashrc
fi

# set user prompt color.
sed -i "s/{green}/{${user_prompt_color}}/g" .bashrc

# remove existing vim profile if it exists.
if [ -d ".vim" ]; then
  rm -Rf ./.vim
fi

cp -f /tmp/scripts/common/tools/vim-files.tar.gz .
tar -zxvf vim-files.tar.gz --no-same-owner --no-overwrite-dir
rm -f vim-files.tar.gz

chown -R ${user_name}:${user_group} .
chmod 644 .bash_profile .bashrc
