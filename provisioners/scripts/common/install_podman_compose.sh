#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Podman Compose CLI tool for Linux 64-bit.
#
# Podman Compose is a thin wrapper around an external compose provider such as docker-compose or
# podman-compose. This means that podman compose is executing another tool that implements the
# compose functionality but sets up the environment in a way to let the compose provider communicate
# transparently with the local Podman socket. The specified options as well the command and argument
# are passed directly to the compose provider.
#
# For more details, please visit:
#   https://github.com/containers/podman-compose
#   https://docs.podman.io/en/latest/markdown/podman-compose.1.html
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] podman compose install parameters [w/ defaults].
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
if [ "$user_name" = "root" ]; then
  echo "Error: 'user_name' should NOT be 'root'."
  usage
  exit 1
fi

# install podman compose. --------------------------------------------------------------------------
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3 -m pip install podman-compose --user" - ${user_name}
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3 -m pip install podman-compose --upgrade --user" - ${user_name}

# validate installation.
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} podman-compose --version" - ${user_name}
