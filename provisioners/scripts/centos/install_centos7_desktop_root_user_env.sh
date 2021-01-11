#!/bin/sh -eux
# create default desktop environment profile for devops 'root' user.

# set default values for input environment variables if not set. -----------------------------------
user_name="root"                                                # user name for 'root' user.
user_home="/root"                                               # user home for 'root' user.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                       # [optional] devops home (defaults to '/opt/devops').

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
