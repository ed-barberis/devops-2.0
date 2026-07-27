#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install K9s CLI cluster manager for Kubernetes.
#
# K9s - Kubernetes CLI To Manage Your Clusters In Style!
#
# K9s provides a terminal UI to interact with your Kubernetes clusters. The aim of this project is
# to make it easier to navigate, observe, and manage your applications in the wild. K9s continually
# watches Kubernetes for changes and offers subsequent commands to interact with your observed
# resources.
#
# For more details, please visit:
#   https://github.com/derailed/k9s
#   https://k9scli.io/topics/commands/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install k9s cli client. --------------------------------------------------------------------------
k9s_release="0.51.0"

# set the packer cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  k9s_binary="k9s_Linux_amd64.tar.gz"
  k9s_sha256="c3752ad51a5a4015a113819c4eeb6e55a4d0e4b8e652494797532f6fc8161dd7"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  k9s_binary="k9s_Linux_arm64.tar.gz"
  k9s_sha256="3ee05c82e5f9198928a4e86133608ba6a2c10a2244d6a7789e820f78319d640c"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download k9s from github.com.
rm -f ${k9s_binary}
curl --silent --location "https://github.com/derailed/k9s/releases/download/v${k9s_release}/${k9s_binary}" --output ${k9s_binary}
chmod 755 ${k9s_binary}

# verify the downloaded binary.
echo "${k9s_sha256} ${k9s_binary}" | sha256sum --check
# k9s_Linux_amd64.tar.gz: OK
# k9s_Linux_arm64.tar.gz: OK

# extract k9s cli binary.
rm -f k9s
tar -zxvf ${k9s_binary} --no-same-owner --no-overwrite-dir k9s
chown root:root k9s
rm -f ${k9s_binary}

# change execute permissions.
chmod 755 k9s

# set helm environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation. -----------------------------------------------------------------------------
k9s version
#k9s info
