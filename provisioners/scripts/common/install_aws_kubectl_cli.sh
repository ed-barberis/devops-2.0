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
#kubectl_release="1.33.0"
#kubectl_date="2025-05-01"
kubectl_release="1.32.3"
kubectl_date="2025-04-17"
#kubectl_release="1.31.7"
#kubectl_date="2025-04-17"
#kubectl_release="1.30.11"
#kubectl_date="2025-04-17"
#kubectl_release="1.29.15"
#kubectl_date="2025-04-17"
#kubectl_release="1.28.15"
#kubectl_date="2025-04-17"
#kubectl_release="1.27.16"
#kubectl_date="2024-12-12"
#kubectl_release="1.26.15"
#kubectl_date="2024-12-12"
#kubectl_release="1.25.16"
#kubectl_date="2024-12-12"
#kubectl_release="1.24.17"
#kubectl_date="2024-12-12"
#kubectl_release="1.23.17"
#kubectl_date="2024-09-11"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.33.0"]="7647610ceb4cc7afb8b3d4b188fece5d2b3c21761a6d2c2c3b050263a80e33f4"
  sha256_values_array["1.32.3"]="80dcf516cccde71e86d2eb610f87bbdbd4f0a4688eb5bfaa9d0caa7875f6be82"
  sha256_values_array["1.31.7"]="a30fff932049ddbb55a44f4125fb0b11da986565d9e39140278a9be3e19d85b4"
  sha256_values_array["1.30.11"]="d7f6d05e4d89d8abb25ac3ea990604f7326db732942293f544b566e8d6d9ace1"
  sha256_values_array["1.29.15"]="893392c4b70d0b28aa2839adfdb7af64c61a40f2630a2c69b01aa431cd29d7b1"
  sha256_values_array["1.28.15"]="84e2e52ff21ab86960741065e50fb9b50e1af335e84c689c453def8842c41830"
  sha256_values_array["1.27.16"]="1813737d0997f372a1be2da6897a638e2a7eb81e5f828e0e0e724f05c50256aa"
  sha256_values_array["1.26.15"]="4dea29aaca9314d089bd8b1829f9c3dec02618c2e44064e92271559175811e24"
  sha256_values_array["1.25.16"]="f8850275ba4f5fbd15474a5ccf5903ab80447ca5396841a2b17ab7ddddf6a114"
  sha256_values_array["1.24.17"]="f4e5ccff4b212507ff2864947b04fcbf68d68cb0f1c4a562fa33e301907c3626"
  sha256_values_array["1.23.17"]="23b46e400d3594d7de611e116746269656d828db7de129c86767a6acf7322d1f"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.33.0"]="0b05efc3834d2491ce4124bb7cf33cb124d7a6bf8767eb501e81003226a34f16"
  sha256_values_array["1.32.3"]="2a49d5891e78e6c55f3df5567737dda6318c7213bc987e6cbf4583a75a158e53"
  sha256_values_array["1.31.7"]="42f8ed97df4d60d1ffe943aa7deda63e801d49851cbe89cb8fa31755ee5fc83f"
  sha256_values_array["1.30.11"]="7e06c13b14300e96bc6f4ed60f591fa287004d45f63b2a6b346012f6d45fadf9"
  sha256_values_array["1.29.15"]="13c9c1b293062c0d07078e9b06434ad90c40560f85e9cac741538e6465b621cf"
  sha256_values_array["1.28.15"]="37b77d8f42f6222f2141925953a585347c649956f9ddf35b18edfcf6cb9362b2"
  sha256_values_array["1.27.16"]="7e103cb0081e88eeccfcae2e9c4616135b289558f5b4fe644fab21a52d36c8c8"
  sha256_values_array["1.26.15"]="f974aee8355790d6b9848c42d64898308a2e2c084c3437a5d720c6444e317db3"
  sha256_values_array["1.25.16"]="329b919f9857f5fe35481d2eb5b1ea30c3a504e39505f540228dd631e0b6b5e0"
  sha256_values_array["1.24.17"]="882ca847ba68622416a1e70b2a17ae28febf82e8da0ef1b6d94084fcb65329d9"
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
