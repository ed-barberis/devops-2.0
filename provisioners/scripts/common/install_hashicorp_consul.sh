#!/bin/sh -eux
# install consul service discovery and configuration tool by hashicorp.

# install hashicorp consul. ----------------------------------------------------
consul_release="1.4.4"
consul_binary="consul_${consul_release}_linux_amd64.zip"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download consul binary from hashicorp.com.
wget --no-verbose https://releases.hashicorp.com/consul/${consul_release}/${consul_binary}

# extract consul binary.
rm -f consul
unzip ${consul_binary}
chmod 755 consul
rm -f ${consul_binary}

# set consul environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
consul --version
