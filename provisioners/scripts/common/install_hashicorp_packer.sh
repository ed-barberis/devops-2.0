#!/bin/sh -eux
# install packer machine and container image tool by hashicorp.

# install hashicorp packer. ----------------------------------------------------
packer_release="1.4.5"
packer_binary="packer_${packer_release}_linux_amd64.zip"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download packer binary from hashicorp.com.
wget --no-verbose https://releases.hashicorp.com/packer/${packer_release}/${packer_binary}

# extract packer binary.
rm -f packer
unzip ${packer_binary}
chmod 755 packer
rm -f ${packer_binary}

# set packer environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
packer --version
