#!/bin/sh -eux
# create default desktop environment profile for devops user.

# set default values for input environment variables if not set. -----------------------------------
user_name="${user_name:-}"
user_home="${user_home:-}"

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"

# define usage function. ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
    [root]# export user_name="user1"                        # user name.
    [root]# export user_home="/home/user1"                  # [optional] user home directory path.
                                                            #
    [root]# export devops_home="/opt/devops"                # [optional] devops home (defaults to '/opt/devops').
    [root]# $0
EOF
}

# validate environment variables. ------------------------------------------------------------------
if [ -z "$user_name" ]; then
  echo "Error: 'user_name' environment variable not set."
  usage
  exit 1
fi

if [ "$user_name" == "root" ]; then
  echo "Error: 'user_name' should NOT be 'root'."
  usage
  exit 1
fi

# if not set, retrieve user home directory path.
if [ -z "$user_home" ]; then
  user_home=$(eval echo "~${user_name}")
fi

# modify default environment profile for the user. -------------------------------------------------
cd ${user_home}

# uncomment proxy environment variables (if set).
proxy_set="${http_proxy:-}"
if [ -n "${proxy_set}" ]; then
  sed -i 's/^#http_proxy/http_proxy/g;s/^#export http_proxy/export http_proxy/g' .bashrc
  sed -i 's/^#https_proxy/https_proxy/g;s/^#export https_proxy/export https_proxy/g' .bashrc
fi

# uncomment gvim alias for desktop users.
sed -i 's/^#alias gvim/alias gvim/g' .bashrc

# configure gnome-3 desktop properties for devops users. -------------------------------------------
#cd ${devops_home}/provisioners/scripts/centos
#chmod 755 config_centos7_gnome_desktop.sh
##sudo -u ${user_name} -S -E sh -eux "${devops_home}/provisioners/scripts/centos/config_centos7_gnome_desktop.sh"
#runuser -c "devops_home=${devops_home} ${devops_home}/provisioners/scripts/centos/config_centos7_gnome_desktop.sh" - ${user_name}
