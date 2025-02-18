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
consul_release="1.20.3"
consul_sha256=""

# set the consul cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  consul_binary="consul_${consul_release}_linux_amd64.zip"
  consul_sha256="23f55df756d6fd9dbf11973738468183599b66e737bf50cd7d1f29ed92a79776"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  consul_binary="consul_${consul_release}_linux_arm64.zip"
  consul_sha256="e67b750f0e204c9d1d5ab62bfcb94e7b86e334b622154495de31d66d5f8f94b4"
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
