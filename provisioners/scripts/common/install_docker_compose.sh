#!/bin/bash -eux
# install docker compose v1.29.2 on arm 64-bit linux.

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] docker compose install parameters [w/ defaults].
user_name="${user_name:-vagrant}"

# define usage function. ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
    [root]# export user_name="vagrant"                          # user name.
    [root]# $0
EOF
}

# validate environment variables. ------------------------------------------------------------------
if [ -z "$user_name" ]; then
  echo "Error: 'user_name' environment variable not set."
  usage
  exit 1
fi

if [ "$user_name" = "root" ]; then
  echo "Error: 'user_name' should NOT be 'root'."
  usage
  exit 1
fi

# install docker-compose utility. ------------------------------------------------------------------
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3 -m pip install setuptools==70.0.0 --user" - ${user_name}
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3 -m pip install docker-compose --user" - ${user_name}
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} docker-compose --version" - ${user_name}
