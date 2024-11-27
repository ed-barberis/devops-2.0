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
#kubectl_release="1.31.2"
#kubectl_date="2024-11-15"
kubectl_release="1.30.6"
kubectl_date="2024-11-15"
#kubectl_release="1.29.10"
#kubectl_date="2024-11-15"
#kubectl_release="1.28.15"
#kubectl_date="2024-11-15"
#kubectl_release="1.27.16"
#kubectl_date="2024-11-15"
#kubectl_release="1.26.15"
#kubectl_date="2024-11-15"
#kubectl_release="1.25.16"
#kubectl_date="2024-11-15"
#kubectl_release="1.24.17"
#kubectl_date="2024-11-15"
#kubectl_release="1.23.17"
#kubectl_date="2024-09-11"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.31.2"]="e9f1ef5bd7098d0e0f4d0690f46b4a822396726d59f96b397c18300ea727c4f5"
  sha256_values_array["1.30.6"]="711f93f24a434c0f6abf675cda994a22862c7e13c0fd36be4e8e8f2599c08dc9"
  sha256_values_array["1.29.10"]="850b3655577f60d93b458d550ae3d2783884a08f26edfa258066a5737f514ae3"
  sha256_values_array["1.28.15"]="398dc2651ac8d3fe0cbfff4af4c29a6a7297a5a76624b70410f035a35443d8cb"
  sha256_values_array["1.27.16"]="5f51172d2c0fc12d4478cdf221469b29db1bc82033b358552b594138ccd07f9d"
  sha256_values_array["1.26.15"]="d91fb220b663f9afda59dfbe1b35db73bffb441d8da11d5da8bab1da7da65b96"
  sha256_values_array["1.25.16"]="f88c48abeca88b474232c759e4b02ec30e71f195fcb025a016e349d6b7a88778"
  sha256_values_array["1.24.17"]="0cbfaded56af3e303a4d0f22d659831f6c85223db506f0b3614943bf86407e97"
  sha256_values_array["1.23.17"]="23b46e400d3594d7de611e116746269656d828db7de129c86767a6acf7322d1f"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.31.2"]="e9443d9f523387d5d0b7540e96ee254528bd385f063a10c17a6cc672e2b34cbb"
  sha256_values_array["1.30.6"]="8eec44c56e641eb22b6439a76afabe07a972cc2e8ca2326db49ef6ec90911d66"
  sha256_values_array["1.29.10"]="56efe1dcc9ceac1b4d6b88909e956d8aed6f586896513ed0dd25a7f8e5d663f2"
  sha256_values_array["1.28.15"]="f2a66f83529aba78677f3ea75a313697561a8b2624aa97e9aa68e38e33c1a404"
  sha256_values_array["1.27.16"]="e9c67c57d236848998932235bce13e729930c002eee7148e6eb4ccf6037286d3"
  sha256_values_array["1.26.15"]="874bb6730348d383451adb117daefb5c117d39e372d129bbae60b49ef9222f14"
  sha256_values_array["1.25.16"]="91f15cd07017f4d26f90563fccb96dfded26bed6786928ad259d3a5a025d4d2d"
  sha256_values_array["1.24.17"]="15beb6db053fb7ec86ad6c66514a67d809668cd990858b7a30b11010de87eedf"
  sha256_values_array["1.23.17"]="721a76d9f9d60cbfaafec1a88f554d324c6750517d17b0d1c59e53ef3483f6f5"

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
