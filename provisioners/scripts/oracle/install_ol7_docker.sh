#!/bin/sh -eux
# install the docker engine on oracle linux 7.x.

# set empty default value for 'http_proxy' if not set. -------------------------
http_proxy="${http_proxy:-}"

# update the repository list. --------------------------------------------------
yum repolist

# install the docker engine. ---------------------------------------------------
yum -y install docker-engine

# configure docker. ------------------------------------------------------------
# if proxy set, configure web proxy networking options.
docker_service_dir="/etc/systemd/system/docker.service.d"
proxy_conf="http-proxy.conf"

if [ -d "$docker_service_dir" ] && [ ! -z "$http_proxy" ]; then
  echo "[Service]" > "${docker_service_dir}/${proxy_conf}"
  echo "Environment=\"HTTP_PROXY=${http_proxy}\"" >> "${docker_service_dir}/${proxy_conf}"
  echo "Environment=\"HTTPS_PROXY=${http_proxy}\"" >> "${docker_service_dir}/${proxy_conf}"
fi

# install the selinux-policy-targeted package.
#yum -y install selinux-policy-targeted

# when the 'mlocate' package is installed, it is recommended to modify
# 'updatedb.conf' to prevent 'updatedb' from indexing directories below
# '/var/lib/docker'.
updatedbfile="/etc/updatedb.conf"
if [ -f "$updatedbfile" ]; then
  sed -i 's/PRUNEPATHS = "/PRUNEPATHS = "\/var\/lib\/docker /g' $updatedbfile
fi

# set docker to use btrfs as the storage file system and notify docker
# that selinux is off.
dockerfile="/etc/sysconfig/docker"
if [ -f "$dockerfile" ]; then
  sed -i "s/OPTIONS='--selinux-enabled'/OPTIONS='--storage-driver btrfs --selinux-enabled=false'/g" $dockerfile
fi

# enable ip forwarding if not set.
sysctlfile="/etc/sysctl.conf"
ipv4cmd="net.ipv4.ip_forward = 1"
if [ -f "$sysctlfile" ]; then
  sysctl net.ipv4.ip_forward
  grep -qF "${ipv4cmd}" ${sysctlfile} || echo "${ipv4cmd}" >> ${sysctlfile}
  sysctl -p /etc/sysctl.conf
  sysctl net.ipv4.ip_forward
fi

# add user 'vagrant' to 'docker' group.
usermod -aG docker vagrant

# start the docker service and configure it to start at boot time.
systemctl start docker
systemctl enable docker

# check that the docker service is running.
systemctl status docker

# display configuration info and verify version.
docker info
docker version
docker --version

# install docker completion for bash. ------------------------------------------
dcompletion_release="17.03.1-ce"
dcompletion_binary=".docker-completion.sh"
userfolder="/home/vagrant"

# download docker completion for bash from github.com.
curl --silent --location "https://github.com/moby/moby/raw/v${dcompletion_release}/contrib/completion/bash/docker" --output ${userfolder}/${dcompletion_binary}
chown -R vagrant:vagrant ${userfolder}/${dcompletion_binary}
chmod 644 ${userfolder}/${dcompletion_binary}

# install docker-compose utility. ----------------------------------------------
dcbin="docker-compose"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d")

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

# install docker compose completion for bash. ----------------------------------
dccompletion_binary=".docker-compose-completion.sh"
userfolder="/home/vagrant"

# download docker completion for bash from github.com.
curl --silent --location "https://github.com/docker/compose/raw/${dcrelease}/contrib/completion/bash/docker-compose" --output ${userfolder}/${dccompletion_binary}
chown -R vagrant:vagrant ${userfolder}/${dccompletion_binary}
chmod 644 ${userfolder}/${dccompletion_binary}
