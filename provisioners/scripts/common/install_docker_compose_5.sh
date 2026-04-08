#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Docker Compose V5 on Linux x86 64-bit.
#
# Docker Compose is a tool for defining and running multi-container applications. It is the key to
# unlocking a streamlined and efficient development and deployment experience.
#
# Compose simplifies the control of your entire application stack, making it easy to manage
# services, networks, and volumes in a single YAML configuration file. Then, with a single command,
# you create and start all the services from your configuration file.
#
# Compose works in all environments--production, staging, development, testing, as well as CI
# workflows. It also has commands for managing the whole lifecycle of your application:
#
#   Start, stop, and rebuild services
#   View the status of running services
#   Stream the log output of running services
#   Run a one-off command on a service
#
# Docker Compose V5 is a major version bump release of Docker Compose.
#
# Why V5?
# We decided to skip 3.0.0 for next major release after docker Compose V2 to prevent (more)
# confusion with the obsolete docker-compose file versions 2.x and 3.x inherited from Docker
# Compose v1. We also skipped 4.0.0 to have a clear separation with this legacy.
#
# For more details, please visit:
#   https://github.com/docker/compose
#   https://docs.docker.com/compose/
#   https://docs.docker.com/compose/install/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install docker compose v5 cli. -------------------------------------------------------------------
dc_release="5.1.1"
dc_home="/usr/local/lib/docker/cli-plugins"
dc_binary="docker-compose-linux-${cpu_arch}"

# set the docker compose sha256 value based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # use the amd64 sha256 value.
  dc_sha256="2ac954c9d506b912a12477d72f01601dc72ec918c429c7bae48fd707bdf0f3e5"
elif [ "$cpu_arch" = "aarch64" ]; then
  # use the arm64 sha256 value.
  dc_sha256="4b5c42952b7dd81f508d01a771df2a9e5dbffe9b8c5c7d983e738504ad38f056"
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
PATH=/usr/local/lib/docker/cli-plugins:$PATH
export PATH

# verify installation.
docker compose version
