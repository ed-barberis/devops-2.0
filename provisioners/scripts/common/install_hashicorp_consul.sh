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

# install hashicorp consul. ------------------------------------------------------------------------
consul_release="1.9.2"
consul_binary="consul_${consul_release}_linux_amd64.zip"
consul_sha256="5141b2e7f54b51e07601d2b4ff1853f1d9b8e26b26bfb55281a8c47d8581352e"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download consul binary from hashicorp.com.
rm -f ${consul_binary}
wget --no-verbose https://releases.hashicorp.com/consul/${consul_release}/${consul_binary}

# verify the downloaded binary.
echo "${consul_sha256} ${consul_binary}" | sha256sum --check
# consul_${consul_release}_linux_amd64.zip: OK

# extract consul binary.
rm -f consul
unzip ${consul_binary}
chmod 755 consul
rm -f ${consul_binary}

# verify installation. -----------------------------------------------------------------------------
# set consul environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify consul version.
consul --version
