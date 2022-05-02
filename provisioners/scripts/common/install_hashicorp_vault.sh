#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Vault Tool for Managing Secrets by HashiCorp.
#
# Secure, store and tightly control access to tokens, passwords, certificates, encryption keys
# for protecting secrets and other sensitive data using a UI, CLI, or HTTP API.
#
# The key use cases for Vault are:
#
# - Secrets Management: Centrally store, access, and deploy secrets across applications,
#   systems, and infrastructure.
# - Data Encryption: Keep application data secure with one centralized workflow to encrypt
#   data in flight and at rest.
# - Identity-based Access: Authenticate and access different clouds, systems, and endpoints
#   using trusted identities.
#
# For more details, please visit:
#   https://vaultproject.io/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# install hashicorp vault. -------------------------------------------------------------------------
vault_release="1.10.2"
vault_binary="vault_${vault_release}_linux_amd64.zip"
vault_sha256="97f355fc435e5e768f1c7f40b6e1c40d6062e01dcfc0adb6b966dab49e9de7d1"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download vault binary from hashicorp.com.
rm -f ${vault_binary}
wget --no-verbose https://releases.hashicorp.com/vault/${vault_release}/${vault_binary}

# verify the downloaded binary.
echo "${vault_sha256} ${vault_binary}" | sha256sum --check
# vault_${vault_release}_linux_amd64.zip: OK

# extract vault binary.
rm -f vault
unzip ${vault_binary}
chmod 755 vault
rm -f ${vault_binary}

# verify installation. -----------------------------------------------------------------------------
# set vault environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify vault version.
vault --version
