#!/bin/sh -eux
# install vault tool for managing secrets by hashicorp.

# install hashicorp vault. -----------------------------------------------------
vault_release="1.0.3"
vault_binary="vault_${vault_release}_linux_amd64.zip"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download vault binary from hashicorp.com.
wget --no-verbose https://releases.hashicorp.com/vault/${vault_release}/${vault_binary}

# extract vault binary.
rm -f vault
unzip ${vault_binary}
chmod 755 vault
rm -f ${vault_binary}

# set vault environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
vault --version
