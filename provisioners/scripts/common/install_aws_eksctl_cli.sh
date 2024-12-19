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
eksctl_release="0.199.0"

# set the eksctl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  eksctl_binary="eksctl_$(uname -s)_amd64.tar.gz"
  eksctl_sha256="0579d378b225507ec1257843f57665d8447a15524fd1d8f55cfab09c34bffca0"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  eksctl_binary="eksctl_$(uname -s)_arm64.tar.gz"
  eksctl_sha256="dec1f5a737e1ff60ff8f3b4d7cb244972ebca6a914b49401e5f8ce4267834e47"
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
