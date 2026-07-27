#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install the Podman Container tools on Ubuntu 64-bit Linux.
#
# The Container Tools encompass software packages required to build and run Linux Containers on
# Ubuntu-based Linux operating systems. The primary piece of software core to this set is Podman,
# but there are many other pieces of software including, but not limited to Buildah and Skopeo.
#
# For more details, please visit:
#   https://podman.io/docs/installation#linux-distributions
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# update the apt repository package indexes. -------------------------------------------------------
apt-get update

# install podman container tools. ------------------------------------------------------------------
apt-get -y install buildah skopeo podman

# install docker-like syntax for the 'podman' command.
apt-get -y install podman-docker

# display configuration info and verify version. ---------------------------------------------------
podman info
podman version
podman --version
