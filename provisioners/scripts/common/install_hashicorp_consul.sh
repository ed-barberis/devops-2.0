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
consul_release="1.19.2"
consul_binary="consul_${consul_release}_linux_amd64.zip"
consul_sha256="9315d95b19cf851f8fb0013b583ede6f61d591a9024a7dbb9b37eee45270abd2"

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
