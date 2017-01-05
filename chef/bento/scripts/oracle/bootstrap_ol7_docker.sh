#!/bin/sh -eux
# install the docker engine on oracle linux 7.x.

# set empty default value for 'http_proxy' if not set. -------------------------
http_proxy="${http_proxy:-}"

# update the repository list. --------------------------------------------------
yum repolist

# install the docker engine. ---------------------------------------------------
yum -y install docker-engine

# if proxy set, configure web proxy networking options. ------------------------
docker_service_dir="/etc/systemd/system/docker.service.d"
proxy_conf="http-proxy.conf"

if [ -d "$docker_service_dir" ] && [ ! -z "$http_proxy" ]; then
  echo "[Service]" > "${docker_service_dir}/${proxy_conf}"
  echo "Environment=\"HTTP_PROXY=${http_proxy}\"" >> "${docker_service_dir}/${proxy_conf}"
  echo "Environment=\"HTTPS_PROXY=${http_proxy}\"" >> "${docker_service_dir}/${proxy_conf}"
fi

# install the selinux-policy-targeted package. ---------------------------------
yum -y install selinux-policy-targeted

# start the docker service and configure it to start at boot time. -------------
#systemctl start docker
#systemctl enable docker

# when the 'mlocate' package is installed, it is recommended to modify ---------
# 'updatedb.conf' to prevent 'updatedb' from indexing directories below
# '/var/lib/docker'.
updatedbfile="/etc/updatedb.conf"
if [ -f "$updatedbfile" ]; then
  sed -i 's/PRUNEPATHS = "/PRUNEPATHS = "\/var\/lib\/docker /g' $updatedbfile
fi

# check that the docker service is running. ------------------------------------
#systemctl status docker

# add user 'vagrant' to 'docker' group.
usermod -aG docker vagrant

# display configuration info and version. --------------------------------------
#docker info
#docker version
docker --version

# create local bin directory (if needed). --------------------------------------
mkdir -p /usr/local/bin
cd /usr/local/bin

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d")

# install docker-compose utility. ----------------------------------------------
dcbin="docker-compose"

# retrieve version number of latest release.
wget --no-verbose --server-response https://github.com/docker/compose/releases/latest >| wget-docker-compose.${curdate}.out 2>&1
dcrelease=$(awk '/Location/ {print $2}' wget-docker-compose.${curdate}.out | awk -F "/" '{print $8}')
rm -f wget-docker-compose.${curdate}.out

# download docker compose utility from github.com.
curl --silent --location "https://github.com/docker/compose/releases/download/${dcrelease}/docker-compose-$(uname -s)-$(uname -m)" --output ${dcbin}
chmod 755 ./${dcbin}

# verify installation.
#docker-compose --version

