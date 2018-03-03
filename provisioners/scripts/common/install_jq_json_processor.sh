#!/bin/sh -eux
# install jq command-line json processor for linux 64-bit.

# install jq json processor. ---------------------------------------------------
jq_release="1.5"
jq_binary="jq-linux64"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download jq binary from github.com.
curl --silent --location "https://github.com/stedolan/jq/releases/download/jq-${jq_release}/${jq_binary}" --output jq

# change execute permissions.
chmod 755 jq

# set jq environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
jq --version
