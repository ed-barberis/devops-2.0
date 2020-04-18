#!/bin/sh -eux
# create default headless (command-line) environment profile for devops user.

# set default values for input environment variables if not set. -----------------------------------
user_name="${user_name:-}"
user_group="${user_group:-}"
user_home="${user_home:-/home/$user_name}"
user_docker_profile="${user_docker_profile:-false}"
user_prompt_color="${user_prompt_color:-green}"
d_completion_release="${d_completion_release:-19.03.8}"
dc_completion_release="${dc_completion_release:-1.25.5}"

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"

# define usage function. ---------------------------------------------------------------------------
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
    [root]# export d_completion_release="19.03.8"               # [optional] docker completion for bash release (defaults to '19.03.8').
    [root]# export dc_completion_release="1.25.5"               # [optional] docker compose completion for bash release (defaults to '1.25.5').
    [root]# export devops_home="/opt/devops"                    # [optional] devops home (defaults to '/opt/devops').
    [root]# $0
EOF
}

# validate environment variables. ------------------------------------------------------------------
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

if [ "$user_name" == "root" ]; then
  echo "Error: 'user_name' should NOT be 'root'."
  usage
  exit 1
fi

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
if [ "$user_docker_profile" == "true" ]; then
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
