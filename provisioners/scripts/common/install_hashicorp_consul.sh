#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Consul Service Discovery and Configuration Tool by HashiCorp.
#
# Consul is a service networking solution to connect and secure services across any runtime
# platform and public or private cloud.
#
# The key features of Consul are:
#
# - Service Discovery
# - Health Checking
# - KV Store
# - Secure Service Communication
# - Multi Datacenter
#
# For more details, please visit:
#   https://consul.io/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install hashicorp consul. ------------------------------------------------------------------------
consul_release="1.21.4"
consul_sha256=""

# set the consul cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  consul_binary="consul_${consul_release}_linux_amd64.zip"
  consul_sha256="a641502dc2bd28e1ed72d3d48a0e8b98c83104d827cf33bee2aed198c0b849df"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  consul_binary="consul_${consul_release}_linux_arm64.zip"
  consul_sha256="50a1b6467a038166684fee25b70ebe9d710e154bd5a179f3e07c655c829646ea"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download consul binary from hashicorp.com.
rm -f ${consul_binary}
wget --no-verbose https://releases.hashicorp.com/consul/${consul_release}/${consul_binary}

# verify the downloaded binary.
echo "${consul_sha256} ${consul_binary}" | sha256sum --check
# consul_${consul_release}_linux_amd64.zip: OK
# consul_${consul_release}_linux_arm64.zip: OK

# extract consul binary.
rm -f consul LICENSE.txt
unzip ${consul_binary} consul
chmod 755 consul
rm -f ${consul_binary}

# verify installation. -----------------------------------------------------------------------------
# set consul environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify consul version.
consul version
