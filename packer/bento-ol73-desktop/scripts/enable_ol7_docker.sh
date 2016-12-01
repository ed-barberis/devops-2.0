#!/bin/sh -eux
# enable the docker engine on oracle linux 7.x.

# start the docker service and configure it to start at boot time. -------------
systemctl start docker
systemctl enable docker

# check that the docker service is running. ------------------------------------
systemctl status docker

# add user 'vagrant' to 'docker' group.
#usermod -aG docker vagrant

# display configuration info and version. --------------------------------------
docker info
docker version
docker --version
