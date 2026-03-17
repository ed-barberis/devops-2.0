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
kubectl_release="1.35.2"
kubectl_date="2026-02-27"
#kubectl_release="1.34.4"
#kubectl_date="2026-02-27"
#kubectl_release="1.33.8"
#kubectl_date="2026-02-27"
#kubectl_release="1.32.12"
#kubectl_date="2026-02-27"
#kubectl_release="1.31.14"
#kubectl_date="2026-02-27"
#kubectl_release="1.30.14"
#kubectl_date="2026-02-27"
#kubectl_release="1.29.15"
#kubectl_date="2026-02-27"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.35.2"]="5b2fc8dd946a9aca7961c5d29cc115365e0649276b7f5f47f822deb444729552"
  sha256_values_array["1.34.4"]="2a75238f5c6bc0e1d7cae871832bdf5913407b9ff0c1d96fd49c5ba1d93c2fcf"
  sha256_values_array["1.33.8"]="59a3f0be0d7fd5c6593fd2a4bf6edbb446c217288539995607b4069dbb19a0a1"
  sha256_values_array["1.32.12"]="3db23d8ee29c7c31a4c0dab92073d0f04bc74197bfc42681420fb2937c557a0f"
  sha256_values_array["1.31.14"]="378d0e8a2cd6948ea42345cd1303625139c2dbd1db4cbbbe53a2c53a9d83ab7c"
  sha256_values_array["1.30.14"]="d86de0fff9ca591a18eddeedcc1cb418a387ba33a3827aa5ad0f50fc8e6b7020"
  sha256_values_array["1.29.15"]="3690136ec4a1450ebc2ce94630e22806c21917c68b8a8d6905862fa528e30378"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.35.2"]="12b5157dd7c967b56585dd2378f67ad3711ae0a9537af7874bdf1fe2206c5cca"
  sha256_values_array["1.34.4"]="42e9b33a460133ee59764da53d1918c81c9bf7b786353d1e74b8d3864b51bd56"
  sha256_values_array["1.33.8"]="265b8486d2d54f9113a90767bfe3979918254d971cab415be7dcc29b7be0cf99"
  sha256_values_array["1.32.12"]="44e390cecbdb9bb6b9598671be023cecf14bbd5477208f7e059f7bf91a5dd102"
  sha256_values_array["1.31.14"]="d06b7aad16da572be9aa36ce16efb8c5d499f1d554474872eb232b648c197c96"
  sha256_values_array["1.30.14"]="bc7c5a89f547b9cdab22d5e9d87e366b7ffc7f8422ba45fda0b417259124a8c5"
  sha256_values_array["1.29.15"]="c751d7b9611f57df1ca23f7b940e4ee771028712de345ab09674ec8d8a221669"

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
