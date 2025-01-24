#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install eksctl CLI for Amazon EKS.
#
# eksctl is a simple CLI tool for creating clusters on EKS - Amazon's new managed Kubernetes
# service for EC2. It is written in Go, and uses CloudFormation.
#
# You can create a cluster in minutes with just one command: 'eksctl create cluster'!
#
# For more details, please visit:
#   https://github.com/weaveworks/eksctl
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install eksctl cli. ------------------------------------------------------------------------------
eksctl_release="0.202.0"

# set the eksctl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  eksctl_binary="eksctl_$(uname -s)_amd64.tar.gz"
  eksctl_sha256="74d44cd60fa00c25248e8adf19cffbba796128b40445f4d199c89f9d89d67598"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  eksctl_binary="eksctl_$(uname -s)_arm64.tar.gz"
  eksctl_sha256="4fd9e69a22a1b3757e60d12d0ac32051e1f373944f8579438439f631861178f0"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download eksctl binary from github.com.
rm -f ${eksctl_binary}
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/v${eksctl_release}/${eksctl_binary}" --output ${eksctl_binary}

# verify the downloaded binary.
echo "${eksctl_sha256} ${eksctl_binary}" | sha256sum --check
# eksctl_$(uname -s)_amd64.tar.gz: OK
# eksctl_$(uname -s)_arm64.tar.gz: OK

# extract eksctl binary.
rm -f eksctl
tar -zxvf ${eksctl_binary} --no-same-owner --no-overwrite-dir
chown root:root eksctl
rm -f ${eksctl_binary}

# change execute permissions.
chmod 755 eksctl

# set eksctl environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
eksctl version
