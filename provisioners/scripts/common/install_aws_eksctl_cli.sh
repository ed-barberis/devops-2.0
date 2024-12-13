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
eksctl_release="0.198.0"

# set the eksctl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  eksctl_binary="eksctl_$(uname -s)_amd64.tar.gz"
  eksctl_sha256="635df0ccd538dc147b35229d217b7f63dcd7989de871466059b894d1d9fd2cb8"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  eksctl_binary="eksctl_$(uname -s)_arm64.tar.gz"
  eksctl_sha256="40d3aad654c33712383d5726de92ca93e86f4676c8d4c66cd5bc91eb7e2b2ef9"
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
