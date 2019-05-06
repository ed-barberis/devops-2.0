#!/bin/sh -eux
# create default desktop environment profile for devops user.

# set default values for input environment variables if not set. -----------------------------------
user_name="${user_name:-}"
user_home="${user_home:-/home/$user_name}"

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
    [root]# export user_home="/home/user1"                  # [optional] user home (defaults to '/home/user_name').
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

# create default environment profile for the user. -------------------------------------------------
if [ "$user_name" == "root" ]; then
  user_bashprofile="${devops_home}/provisioners/scripts/common/users/user-root-bash_profile.sh"
  user_bashrc="${devops_home}/provisioners/scripts/common/users/user-root-bashrc.sh"
  user_home="/root"                                         # override user home for 'root' user.
else
  user_bashprofile="${devops_home}/provisioners/scripts/common/users/user-vagrant-bash_profile.sh"
  user_bashrc="${devops_home}/provisioners/scripts/common/users/user-vagrant-bashrc.sh"

  # uncomment postman home path for desktop users.
  sed -i 's/^#POSTMAN_HOME/POSTMAN_HOME/g;s/^#export POSTMAN_HOME/export POSTMAN_HOME/g' ${user_bashrc}
  sed -i 's/^PATH=/##PATH=/g;s/^#PATH=/PATH=/g;s/^##PATH=/#PATH=/g' ${user_bashrc}
fi

# uncomment gvim alias for desktop users.
sed -i 's/^#alias gvim/alias gvim/g' ${user_bashrc}

# create default environment profile for the user. -------------------------------------------------
cd ${user_home}
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f ${user_bashprofile} .bash_profile
cp -f ${user_bashrc} .bashrc

# configure gnome-3 desktop properties for devops users. -------------------------------------------
cd ${devops_home}/provisioners/scripts/centos
chmod 755 config_centos7_gnome_desktop.sh
#sudo -u ${user_name} -S -E sh -eux "${devops_home}/provisioners/scripts/centos/config_centos7_gnome_desktop.sh"
runuser -c "devops_home=${devops_home} ${devops_home}/provisioners/scripts/centos/config_centos7_gnome_desktop.sh" - ${user_name}
