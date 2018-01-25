#!/bin/sh -eux
# create default desktop environment profile for devops user.

# set default values for input environment variables if not set. ---------------
user_name="${user_name:-}"                                  # user name.
user_home="${user_home:-/home/$user_name}"                  # [optional] user home (defaults to '/home/user_name').

# define usage function. -------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
    [root]# export user_name="user1"                        # user name.
    [root]# export user_home="/home/user1"                  # [optional] user home (defaults to '/home/user_name').
    [root]# $0
EOF
}

# validate environment variables. ----------------------------------------------
if [ -z "$user_name" ]; then
  echo "Error: 'user_name' environment variable not set."
  usage
  exit 1
fi

# create default environment profile for the user. -----------------------------
cd ${user_home}

# uncomment postman home path for desktop users.
sed -i 's/^#POSTMAN_HOME/POSTMAN_HOME/g;s/^#export POSTMAN_HOME/export POSTMAN_HOME/g' .bashrc
sed -i 's/^PATH=/##PATH=/g;s/^#PATH=/PATH=/g;s/^##PATH=/#PATH=/g' .bashrc

# uncomment gvim alias for desktop users.
sed -i 's/^#alias gvim/alias gvim/g' .bashrc

# configure gnome-3 desktop properties for devops users. -----------------------
cd /tmp/scripts/centos
chmod 755 config_centos7_gnome_desktop.sh
runuser -c "/tmp/scripts/centos/config_centos7_gnome_desktop.sh" - ${user_name}
