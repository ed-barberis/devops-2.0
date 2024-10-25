#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Jsonnet Bundler 'jb' package manager for Jsonnet.
#
# The Jsonnet Bundler project is a package manager for Jsonnet to share and reuse code across the
# internet, similar to 'npm' or 'go mod'. Jsonnet is a configuration language for app and tool
# developers which expresses your apps more obviously than YAML.
#
# For more details, please visit:
#   https://github.com/jsonnet-bundler/jsonnet-bundler
#   https://tanka.dev/install/
#   https://jsonnet.org/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# install jsonnet bundler cli client. --------------------------------------------------------------
###jsonnet_bundler_release="0.6.0"
###jsonnet_bundler_binary="jb-linux-amd64"
###jsonnet_bundler_sha256="78e54afbbc3ff3e0942b1576b4992277df4f6beb64cddd58528a76f0cd70db54"

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download jsonnet bundler from github.com.
rm -f jb
curl --silent --location "https://github.com/jsonnet-bundler/jsonnet-bundler/releases/latest/download/jb-linux-amd64" --output jb
###curl --silent --location "https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v${jsonnet_bundler_release}/${jsonnet_bundler_binary}" --output jb

# change owner and execute permissions.
chown root:root jb
chmod 755 jb

# verify the downloaded binary.
###echo "${jsonnet_bundler_sha256} jb" | sha256sum --check
# jb: OK

# set jb environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation. -----------------------------------------------------------------------------
jb --version
