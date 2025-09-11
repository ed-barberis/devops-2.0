#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Docker Compose v2 on Linux x86 64-bit.
#
# Docker Compose is a tool for running multi-container applications on Docker defined using the
# Compose file format. A Compose file is used to define how one or more containers that make up
# your application are configured. Once you have a Compose file, you can create and start your
# application with a single command: 'docker compose up'.
#
# Docker Compose V2 is a major version bump release of Docker Compose. It has been completely
# rewritten from scratch in Golang (V1 was in Python). The installation instructions for Compose V2
# differ from V1. V2 is not a standalone binary anymore, and installation scripts will have to be
# adjusted. Some commands are different.
#
# For a smooth transition from legacy docker-compose 1.xx, please consider installing
# i'compose-switch' to translate 'docker-compose' commands into Compose V2's docker compose. Also
# check V2's --compatibility flag.
#
# For more details, please visit:
#   https://github.com/docker/compose
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install docker compose v2 cli. -------------------------------------------------------------------
dc_release="2.39.3"
dc_home="/usr/libexec/docker/cli-plugins"
dc_binary="docker-compose-linux-${cpu_arch}"

# set the docker compose sha256 value based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # use the amd64 sha256 value.
  dc_sha256="065836e21bce25674d2876dc64321ac707808fcd120e1c3ba700b0ce5ce8ff16"
elif [ "$cpu_arch" = "aarch64" ]; then
  # use the arm64 sha256 value.
  dc_sha256="1607ff1b288ea5acd93d6a2c5a4f53ecd1e237e6e17e7babb0f540a24d667f33"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create docker cli-plugins directory (if needed).
mkdir -p ${dc_home}
cd ${dc_home}

# download docker compose binary from github.com.
rm -f ${dc_binary} docker-compose
curl --silent --location "https://github.com/docker/compose/releases/download/v${dc_release}/${dc_binary}" --output docker-compose
chown root:root docker-compose

# verify the downloaded binary.
echo "${dc_sha256} docker-compose" | sha256sum --check
# docker-compose: OK

# change execute permissions.
chmod 755 docker-compose

# set docker compose home environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
docker compose version
