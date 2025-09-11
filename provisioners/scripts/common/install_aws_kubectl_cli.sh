#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install kubectl CLI for Amazon EKS.
#
# Kubernetes uses a command-line utility called kubectl for communicating with the cluster
# API server to deploy and manage applications on Kubernetes. Using kubectl, you can inspect
# cluster resources; create, delete, and update components; look at your new cluster; and
# bring up example apps.
#
# For more details, please visit:
#   https://kubernetes.io/docs/concepts/
#   https://kubernetes.io/docs/tasks/tools/install-kubectl/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install kubectl cli. -----------------------------------------------------------------------------
kubectl_release="1.33.4"
kubectl_date="2025-08-20"
#kubectl_release="1.32.8"
#kubectl_date="2025-08-20"
#kubectl_release="1.31.12"
#kubectl_date="2025-08-20"
#kubectl_release="1.30.14"
#kubectl_date="2025-08-20"
#kubectl_release="1.29.15"
#kubectl_date="2025-08-20"
#kubectl_release="1.28.15"
#kubectl_date="2025-08-20"
#kubectl_release="1.27.16"
#kubectl_date="2024-12-12"
#kubectl_release="1.26.15"
#kubectl_date="2024-12-12"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.33.4"]="70bd28dea40a4a2a90c6888038b852689ac0700e2cf89b9722a66df79fcc358e"
  sha256_values_array["1.32.8"]="5ba448da817f51fb3977bff44a3d3d210b79c3d245f2c5b0193df8e568493617"
  sha256_values_array["1.31.12"]="3f9e09814afe0f1b1852fa631747e77c2bd3662591e2b3423873c8724663a1a5"
  sha256_values_array["1.30.14"]="4f542d759d2783a64de4faf03668dcb0437723202a4a8ea611f8a88674c1ccc8"
  sha256_values_array["1.29.15"]="d90416e939ba200364b26d67feb33069e258c755ed7f4f3c5c8d20c6ac14a8f2"
  sha256_values_array["1.28.15"]="4c688a069da01e2e1284f51035623e86d2db3a0d467cf8b1c246e17b2011edd7"
  sha256_values_array["1.27.16"]="1813737d0997f372a1be2da6897a638e2a7eb81e5f828e0e0e724f05c50256aa"
  sha256_values_array["1.26.15"]="4dea29aaca9314d089bd8b1829f9c3dec02618c2e44064e92271559175811e24"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.33.4"]="00886480634d4650dfb5c9977a0c1af083a164067c1a12547cb52319042b468a"
  sha256_values_array["1.32.8"]="19ceeb41ecdfa64d4f1bf7e1bc13322d51b5d13b153a173199af9bd4965d5734"
  sha256_values_array["1.31.12"]="7a516eb5d0983b02ee2ba78a5e6112fc49c1139f5b092ecf4edb7c34129c7d9a"
  sha256_values_array["1.30.14"]="d471ba2da7cbca5943c35134cd37f0102985882381835eab2e25553cfa7e55d6"
  sha256_values_array["1.29.15"]="e6cb61a8a2a0b64919842902d0c43bad2210d947018fd8ac4b7946684d29f154"
  sha256_values_array["1.28.15"]="08d7c8f82468a1948ff60a5f1becf6d935085802e1b44f3cbfd632fbaab32ff2"
  sha256_values_array["1.27.16"]="7e103cb0081e88eeccfcae2e9c4616135b289558f5b4fe644fab21a52d36c8c8"
  sha256_values_array["1.26.15"]="f974aee8355790d6b9848c42d64898308a2e2c084c3437a5d720c6444e317db3"

  # set the arm64 download path.
  kubectl_path="arm64"

else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download kubectl binary from github.com.
rm -f kubectl
curl --silent --location "https://s3.us-west-2.amazonaws.com/amazon-eks/${kubectl_release}/${kubectl_date}/bin/linux/${kubectl_path}/kubectl" --output kubectl
chown root:root kubectl

# verify the downloaded binary.
echo "${sha256_values_array[${kubectl_release}]} kubectl" | sha256sum --check
# kubectl: OK

# change execute permissions.
chmod 755 kubectl

# set kubectl environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
if [[ "$kubectl_release" < "1.28.0" ]]; then
  kubectl version --short --client
else
  kubectl version --client
fi

#export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config
