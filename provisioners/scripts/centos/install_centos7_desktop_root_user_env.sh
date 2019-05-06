#!/bin/sh -eux
# create default desktop environment profile for devops 'root' user.

# set default values for input environment variables if not set. -----------------------------------
user_name="root"                                                # user name for 'root' user.
user_home="/root"                                               # user home for 'root' user.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                       # [optional] devops home (defaults to '/opt/devops').

# create default environment profile for the user. -------------------------------------------------
root_bashprofile="${devops_home}/provisioners/scripts/common/users/user-root-bash_profile.sh"
root_bashrc="${devops_home}/provisioners/scripts/common/users/user-root-bashrc.sh"

# uncomment gvim alias for desktop users.
sed -i 's/^#alias gvim/alias gvim/g' ${root_bashrc}

# create default environment profile for the user. -------------------------------------------------
cd ${user_home}
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f ${root_bashprofile} .bash_profile
cp -f ${root_bashrc} .bashrc
