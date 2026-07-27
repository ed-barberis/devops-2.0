#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install Podman Compose CLI tool for Ubuntu 64-bit Linux.
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

# update the apt repository package indexes. -------------------------------------------------------
apt-get update

# install podman compose cli tool. -----------------------------------------------------------------
apt-get -y install podman-compose

# verify version. ----------------------------------------------------------------------------------
podman-compose --version
