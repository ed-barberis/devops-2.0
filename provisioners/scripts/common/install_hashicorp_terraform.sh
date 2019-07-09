#!/bin/sh -eux
# install terraform infrastructure as code tool by hashicorp.

# install hashicorp terraform. ---------------------------------------------------------------------
terraform_release="0.12.3"
terraform_binary="terraform_${terraform_release}_linux_amd64.zip"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download terraform binary from hashicorp.com.
wget --no-verbose https://releases.hashicorp.com/terraform/${terraform_release}/${terraform_binary}

# extract terraform binary.
rm -f terraform
unzip ${terraform_binary}
chmod 755 terraform
rm -f ${terraform_binary}

# set terraform environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
terraform --version
