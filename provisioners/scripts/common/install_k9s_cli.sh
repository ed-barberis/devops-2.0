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

# install k9s cli client. --------------------------------------------------------------------------
k9s_release="0.32.5"
k9s_binary="k9s_Linux_amd64.tar.gz"
k9s_sha256="33c31bf5feba292b59b8dabe5547cb52ab565521ee5619b52eb4bd4bf226cea3"

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
