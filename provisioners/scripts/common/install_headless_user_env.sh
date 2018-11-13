#!/bin/sh -eux
# create default headless (command-line) environment profile for devops user.

# set default values for input environment variables if not set. ---------------
user_name="${user_name:-}"                                      # user name.
user_group="${user_group:-}"                                    # user login group.
user_home="${user_home:-/home/$user_name}"                      # [optional] user home (defaults to '/home/user_name').
user_docker_profile="${user_docker_profile:-false}"             # [optional] user docker profile (defaults to 'false').
user_prompt_color="${user_prompt_color:-green}"                 # [optional] user prompt color (defaults to 'green').
                                                                #            valid colors are:
                                                                #              'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                       # [optional] devops home (defaults to '/opt/devops').

# define usage function. -------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with correct privilege for the given user name.
  Example:
    [root]# export user_name="user1"                            # user name.
    [root]# export user_group="group1"                          # user login group.
    [root]# export user_home="/home/user1"                      # [optional] user home (defaults to '/home/user_name').
    [root]# export user_docker_profile="true"                   # [optional] user docker profile (defaults to 'false').
    [root]# export user_prompt_color="yellow"                   # [optional] user prompt color (defaults to 'green').
                                                                #            valid colors:
                                                                #              'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'
                                                                #
    [root]# export devops_home="/opt/devops"                    # [optional] devops home (defaults to '/opt/devops').
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

if [ -n "$user_prompt_color" ]; then
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
  master_bashprofile="${devops_home}/provisioners/scripts/common/users/user-root-bash_profile.sh"
  master_bashrc="${devops_home}/provisioners/scripts/common/users/user-root-bashrc.sh"
  user_home="/root"                                         # override user home for 'root' user.
else
  master_bashprofile="${devops_home}/provisioners/scripts/common/users/user-vagrant-bash_profile.sh"
  master_bashrc="${devops_home}/provisioners/scripts/common/users/user-vagrant-bashrc.sh"
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

cp -f ${devops_home}/provisioners/scripts/common/tools/vim-files.tar.gz .
tar -zxvf vim-files.tar.gz --no-same-owner --no-overwrite-dir
rm -f vim-files.tar.gz

chown -R ${user_name}:${user_group} .
chmod 644 .bash_profile .bashrc

# create docker profile for the user. ------------------------------------------
if [ "$user_docker_profile" == "true" ] && [ "$user_name" != "root" ]; then
  # add user to the 'docker' group.
  usermod -aG docker ${user_name}

  # install docker completion for bash.
  dcompletion_release="18.09.0"
  dcompletion_binary=".docker-completion.sh"

  # download docker completion for bash from github.com.
  rm -f ${user_home}/${dcompletion_binary}
  curl --silent --location "https://github.com/docker/cli/raw/v${dcompletion_release}/contrib/completion/bash/docker" --output ${user_home}/${dcompletion_binary}
  chown -R ${user_name}:${user_group} ${user_home}/${dcompletion_binary}
  chmod 644 ${user_home}/${dcompletion_binary}

  # install docker compose completion for bash.
  dcrelease="1.23.1"
  dccompletion_binary=".docker-compose-completion.sh"

  # download docker completion for bash from github.com.
  rm -f ${user_home}/${dccompletion_binary}
  curl --silent --location "https://github.com/docker/compose/raw/${dcrelease}/contrib/completion/bash/docker-compose" --output ${user_home}/${dccompletion_binary}
  chown -R ${user_name}:${user_group} ${user_home}/${dccompletion_binary}
  chmod 644 ${user_home}/${dccompletion_binary}
fi
