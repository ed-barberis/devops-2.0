#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install kubectl CLI for Linux.
#
# Kubernetes uses a command-line utility called kubectl for communicating with the cluster
# API server to deploy and manage applications on Kubernetes. Using kubectl, you can inspect
# cluster resources; create, delete, and update components; look at your new cluster; and
# bring up example apps.
#
# For more details, please visit:
#   https://kubernetes.io/docs/concepts/
#   https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
#   https://github.com/kubernetes/kubectl
#
# To list supported Kubernetes versions for GKE in a specific region/zone:
#   gcloud container get-server-config --region=us-central1
#   gcloud container get-server-config --zone=us-central1-a
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] kubectl install parameters [w/ defaults].
#kubectl_release="${kubectl_release:-1.35.3}"
kubectl_release="${kubectl_release:-1.34.6}"
#kubectl_release="${kubectl_release:-1.33.10}"
#kubectl_release="${kubectl_release:-1.32.13}"
#kubectl_release="${kubectl_release:-1.31.14}"
#kubectl_release="${kubectl_release:-1.30.14}"
#kubectl_release="${kubectl_release:-1.29.15}"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.35.3"]="fd31c7d7129260e608f6faf92d5984c3267ad0b5ead3bced2fe125686e286ad6"
  sha256_values_array["1.34.6"]="3166155b17198c0af34ff5a360bd4d9d58db98bafadc6f3c2a57ae560563cd6b"
  sha256_values_array["1.33.10"]="f156acb753ee4366789ab7a663916eb580e7ee1b9e449bc9b052181db524e3f5"
  sha256_values_array["1.32.13"]="db2ae479a63f3665d7f704ab18c0d4d4050144237980763221835b7305703c4c"
  sha256_values_array["1.31.14"]="8791ec7c8966b61420d55103a5fb948de9f0ca3d7306d789734975ad9704bdb0"
  sha256_values_array["1.30.14"]="7ccac981ece0098284d8961973295f5124d78eab7b89ba5023f35591baa16271"
  sha256_values_array["1.29.15"]="3473e14c7b024a6e5403c6401b273b3faff8e5b1fed022d633815eb3168e4516"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.35.3"]="6f0cd088a82dde5d5807122056069e2fac4ed447cc518efc055547ae46525f14"
  sha256_values_array["1.34.6"]="a49a439f83f504e6bc051f516a8baf8d2220d74110f7f9bcaf25feac69e368d1"
  sha256_values_array["1.33.10"]="e9494229893ccddc81065275c0e5f21167518ab939f0e95aecb649fb4b41c112"
  sha256_values_array["1.32.13"]="b1f87f196633a89208546d79bfa4e2470bda70e7bf42c4d3adb008ec208da9d1"
  sha256_values_array["1.31.14"]="3abb0c2d7121e1833831f56fd857a93de386e76d14b64baf86220d0afe495209"
  sha256_values_array["1.30.14"]="a32e46ae15fe41292dc6a7cd76beba7104282a5a3fa9e3686319000a537f4f5d"
  sha256_values_array["1.29.15"]="a41984dc0ff34ee05f1283ebd9b3121c003b3469b97214738246faa5b6788f7c"

  # set the arm64 download path.
  kubectl_path="arm64"

else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# install kubectl cli. -----------------------------------------------------------------------------
# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download kubectl binary from github.com.
rm -f kubectl
curl --silent --location "https://dl.k8s.io/release/v${kubectl_release}/bin/linux/${kubectl_path}/kubectl" --output kubectl
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
