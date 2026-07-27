#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install the Docker Engine on Ubuntu Linux.
#
# Docker is an open platform for developing, shipping, and running applications. Docker enables you
# to separate your applications from your infrastructure so you can deliver software quickly. With
# Docker, you can manage your infrastructure in the same ways you manage your applications. By
# taking advantage of Docker’s methodologies for shipping, testing, and deploying code quickly, you
# can significantly reduce the delay between writing code and running it in production.
#
# For more details, please visit:
#   https://docs.docker.com/get-started/overview/
#   https://docs.docker.com/engine/install/ubuntu/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# update the apt repository package indexes. -------------------------------------------------------
apt-get update

# install tools needed to install docker. ----------------------------------------------------------
apt-get -y install ca-certificates curl

# import the official docker gpg key and add the docker repository. --------------------------------
# import the docker gpg key.
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# add the docker repository to apt sources.
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# install docker on ubuntu. ------------------------------------------------------------------------
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# verify the docker installation. ------------------------------------------------------------------
# start the docker service and configure it to start at boot time.
#systemctl start docker
#systemctl enable docker

# check that the docker service is running.
#systemctl status docker

# display configuration info and verify version.
#docker info
#docker version
docker --version
