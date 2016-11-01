#!/bin/bash
# enable the docker engine on oracle linux 7.x.

# start the docker service and configure it to start at boot time. -------------
echo ""
echo "-----------------------------------------------------------"
echo "Configuring the docker service..."
echo "-----------------------------------------------------------"
echo "Starting the docker service..."
systemctl start docker
echo ""

echo "Configuring docker to run at boot time..."
systemctl enable docker
echo "-----------------------------------------------------------"
echo ""

# check that the docker service is running. ------------------------------------
echo ""
echo "-----------------------------------------------------------"
echo "Checking docker service status..."
echo "-----------------------------------------------------------"
systemctl status docker
echo "-----------------------------------------------------------"
echo ""

# add user 'vagrant' to 'docker' group.
#usermod -aG docker vagrant

# display configuration info and version. --------------------------------------
echo ""
echo "-----------------------------------------------------------"
echo "Report docker information and version..."
echo "-----------------------------------------------------------"
echo "displaying docker information..."
docker info
echo ""

echo "displaying docker version..."
docker version
echo ""

echo "docker binary version..."
docker --version
echo "-----------------------------------------------------------"
echo ""
