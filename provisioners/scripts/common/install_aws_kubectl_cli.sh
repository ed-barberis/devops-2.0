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
kubectl_release="1.36.2"
kubectl_date="2026-07-05"
#kubectl_release="1.35.6"
#kubectl_date="2026-07-05"
#kubectl_release="1.34.9"
#kubectl_date="2026-07-05"
#kubectl_release="1.33.13"
#kubectl_date="2026-07-05"
#kubectl_release="1.32.13"
#kubectl_date="2026-07-05"
#kubectl_release="1.31.14"
#kubectl_date="2026-07-05"
#kubectl_release="1.30.14"
#kubectl_date="2026-07-05"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.36.2"]="485546d8b76a97f01f63c36716b6412a87a89c6eed3d4495041660ff6b6b62d4"
  sha256_values_array["1.35.6"]="4df214687713f2edce9519c76b3dc6658ddc7503c6b29e6affc4976dbd720e32"
  sha256_values_array["1.34.9"]="23b7520541d0302cfde462a9193ae444decbd0c7c6fc93ffe890cef8225368b6"
  sha256_values_array["1.33.13"]="886621cc3be992e79bbe034ec73b58f0543921a4532d5a428fad0230e62e8e55"
  sha256_values_array["1.32.13"]="552834df05bab1c6657fffa9a2bebf05b525747d3df69fd904835fa18c0b2d29"
  sha256_values_array["1.31.14"]="32a70c0de07e185da08d8027e248b0f497bc86821f7e417c948842c7aaa3b730"
  sha256_values_array["1.30.14"]="333226016923e070fa5a97d4f51c2b5f4ce928f8687a33a9b0d6b872299d2164"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.36.2"]="ad06b385142ec8aea1964ccb80ee1100b33eeeba208643ea314a8e5b886a8356"
  sha256_values_array["1.35.6"]="2f987b81b227f9c90ab6c74d36380d67ebee02baddfc978da894f2a05960be60"
  sha256_values_array["1.34.9"]="9e79830966e3913c3addf383aef55149160bc2a5a432175e8c12c35aa4b3d385"
  sha256_values_array["1.33.13"]="181a6de43c20e740a979f05caf256c06172c487fa9254d6c939c703a5361a53d"
  sha256_values_array["1.32.13"]="36b509a8da6ea847b554fd8cac2b32ed6d8c0f32faaba3846f810e7afab327a1"
  sha256_values_array["1.31.14"]="20624dcbe1655e5233bbe9897ba9e2f9c814bdb9eccc67c22a153ab7a88746cc"
  sha256_values_array["1.30.14"]="db44783138f61eb42422f606e970bdd87168ecfc16a19f6681dfe1428e695fbd"

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
