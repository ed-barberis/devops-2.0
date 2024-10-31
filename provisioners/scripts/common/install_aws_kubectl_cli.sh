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
#kubectl_release="1.31.0"
#kubectl_date="2024-09-12"
kubectl_release="1.30.4"
kubectl_date="2024-09-11"
#kubectl_release="1.29.8"
#kubectl_date="2024-09-11"
#kubectl_release="1.28.13"
#kubectl_date="2024-09-11"
#kubectl_release="1.27.16"
#kubectl_date="2024-09-11"
#kubectl_release="1.26.15"
#kubectl_date="2024-09-11"
#kubectl_release="1.25.16"
#kubectl_date="2024-09-11"
#kubectl_release="1.24.17"
#kubectl_date="2024-09-11"
#kubectl_release="1.23.17"
#kubectl_date="2024-09-11"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.31.0"]="d2a1ea84b478d1d2e85d6a9d4ba4b33330eef8009bfba7a2fd01b2b3b0359cfb"
  sha256_values_array["1.30.4"]="ef7f590e4034e1a4bde8dfa77287f636c18085b671b2d32228964bc344b0aa71"
  sha256_values_array["1.29.8"]="4881ff1c7f2fa5a29427ffc6f766e03568bd087836ca6c2252bcca92ea42d205"
  sha256_values_array["1.28.13"]="e4e618cc813bc9b9d7fa0645ea12b6bc7418a5cc71518a2209d6f299954a5f7d"
  sha256_values_array["1.27.16"]="3e2273aae5a971b8754ca09b60deb35ae060e0e1c075422bced0dbb6838d0b55"
  sha256_values_array["1.26.15"]="2bfb0f55173b17d9fbb2f6e12577b1165a949c4a8a81412caefc897515231bd9"
  sha256_values_array["1.25.16"]="c331e99b318fd07b68809f8e4d6de2cc6a4c69bed4fc173352473fd029b6154a"
  sha256_values_array["1.24.17"]="dfa1472706289a105c8c4bdf21c29d4a2478bc427c0fdaaef784ac1b760f2f55"
  sha256_values_array["1.23.17"]="23b46e400d3594d7de611e116746269656d828db7de129c86767a6acf7322d1f"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.31.0"]="3cc39b9440a0002d11fb1c508cd6a68840ad37f4f172c0dedc187777332acb91"
  sha256_values_array["1.30.4"]="74635afd1d00f292ea7fbfbf2bb0f3ee0af9f89bd83fe53aa28d814828ecc8b5"
  sha256_values_array["1.29.8"]="9a4a69d2bb7e7879fd8f39419051071c1d91986d02faffbfcbf9f7ea9fa20ae1"
  sha256_values_array["1.28.13"]="a596947994d90808d2831dca4534be1bebcfdc1f1f641e385ac348a87621cb61"
  sha256_values_array["1.27.16"]="088887da878cad8f188161925b43554e951a2ede9e7a5f6e60e965a0635fa758"
  sha256_values_array["1.26.15"]="89e5cb41aba0fe7675e6c7a43a7bc9df1e3f1cfc5e41de34b27dcf61b7f548fe"
  sha256_values_array["1.25.16"]="357c58c59d74955b193ca5359d7cd4e8aca6efc2997f9251bbe9dbfae389839f"
  sha256_values_array["1.24.17"]="8fb1ec0124a9ca05d07b37a2a8acfdfc45e2d1d070cd226b4fe923574662a7da"
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
