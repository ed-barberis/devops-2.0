#!/bin/sh -eux
# install the docker engine on centos 7.x.

# install the docker prerequisites. --------------------------------------------
yum -y install yum-utils
yum -y install device-mapper-persistent-data
yum -y install lvm2

# install the docker repository. -----------------------------------------------
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# enable/disable optional docker repositories.
# note: starting with docker 17.06, stable releases are also pushed to the
# edge and test repositories.
#yum-config-manager --enable docker-ce-edge      # optional.
#yum-config-manager --enable docker-ce-test      # optional.

#yum-config-manager --disable docker-ce-edge     # optional.
#yum-config-manager --disable docker-ce-test     # optional.
#yum list docker-ce --showduplicates | sort -r

# install the docker community edition engine. ---------------------------------
yum -y install docker-ce

# configure docker. ------------------------------------------------------------
# enable ip forwarding if not set.
sysctlfile="/etc/sysctl.conf"
ipv4cmd="net.ipv4.ip_forward = 1"
if [ -f "$sysctlfile" ]; then
  sysctl net.ipv4.ip_forward
  grep -qF "${ipv4cmd}" ${sysctlfile} || echo "${ipv4cmd}" >> ${sysctlfile}
  sysctl -p /etc/sysctl.conf
  sysctl net.ipv4.ip_forward
fi

# start the docker service and configure it to start at boot time.
systemctl start docker
systemctl enable docker

# check that the docker service is running.
systemctl status docker

# display configuration info and verify version.
docker info
docker version
docker --version

# install docker-compose utility. ----------------------------------------------
dcbin="docker-compose"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# retrieve version number of latest release.
curl --silent --dump-header curl-docker-compose.${curdate}.out1 https://github.com/docker/compose/releases/latest --output /dev/null
tr -d '\r' < curl-docker-compose.${curdate}.out1 > curl-docker-compose.${curdate}.out2
dcrelease=$(awk '/Location/ {print $2}' curl-docker-compose.${curdate}.out2 | awk -F "/" '{print $8}')
rm -f curl-docker-compose.${curdate}.out1
rm -f curl-docker-compose.${curdate}.out2

# download docker compose utility from github.com.
curl --silent --location "https://github.com/docker/compose/releases/download/${dcrelease}/docker-compose-$(uname -s)-$(uname -m)" --output ${dcbin}
chmod 755 ./${dcbin}

# set docker-compose home environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
docker-compose --version
