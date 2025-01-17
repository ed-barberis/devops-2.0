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
#kubectl_release="${kubectl_release:-1.32.1}"
#kubectl_release="${kubectl_release:-1.31.5}"
kubectl_release="${kubectl_release:-1.30.9}"
#kubectl_release="${kubectl_release:-1.29.13}"
#kubectl_release="${kubectl_release:-1.28.15}"
#kubectl_release="${kubectl_release:-1.27.16}"
#kubectl_release="${kubectl_release:-1.26.15}"
#kubectl_release="${kubectl_release:-1.25.16}"
#kubectl_release="${kubectl_release:-1.24.17}"
#kubectl_release="${kubectl_release:-1.23.17}"
#kubectl_release="${kubectl_release:-1.22.17}"
#kubectl_release="${kubectl_release:-1.21.14}"
#kubectl_release="${kubectl_release:-1.20.15}"
#kubectl_release="${kubectl_release:-1.19.16}"
#kubectl_release="${kubectl_release:-1.18.19}"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.32.1"]="e16c80f1a9f94db31063477eb9e61a2e24c1a4eee09ba776b029048f5369db0c"
  sha256_values_array["1.31.5"]="fbecbfd375b3686002c2e81d51c390172f5ffba3d6b47920d55342cb03f557af"
  sha256_values_array["1.30.9"]="d77041f285d9237c4aa451370c3ec6e5c042007dbb55c894f0a179b1d149bf32"
  sha256_values_array["1.29.13"]="9f4cba9b3e12a3fd7fa99dee651d7293281333469852a8e755a1210d5b128b8d"
  sha256_values_array["1.28.15"]="1f7651ad0b50ef4561aa82e77f3ad06599b5e6b0b2a5fb6c4f474d95a77e41c5"
  sha256_values_array["1.27.16"]="97ea7cd771d0c6e3332614668a40d2c5996f0053ff11b44b198ea84dba0818cb"
  sha256_values_array["1.26.15"]="b75f359e6fad3cdbf05a0ee9d5872c43383683bb8527a9e078bb5b8a44350a41"
  sha256_values_array["1.25.16"]="5a9bc1d3ebfc7f6f812042d5f97b82730f2bdda47634b67bddf36ed23819ab17"
  sha256_values_array["1.24.17"]="3e9588e3326c7110a163103fc3ea101bb0e85f4d6fd228cf928fa9a2a20594d5"
  sha256_values_array["1.23.17"]="f09f7338b5a677f17a9443796c648d2b80feaec9d6a094ab79a77c8a01fde941"
  sha256_values_array["1.22.17"]="7506a0ae7a59b35089853e1da2b0b9ac0258c5309ea3d165c3412904a9051d48"
  sha256_values_array["1.21.14"]="0c1682493c2abd7bc5fe4ddcdb0b6e5d417aa7e067994ffeca964163a988c6ee"
  sha256_values_array["1.20.15"]="d283552d3ef3b0fd47c08953414e1e73897a1b3f88c8a520bb2e7de4e37e96f3"
  sha256_values_array["1.19.16"]="6b9d9315877c624097630ac3c9a13f1f7603be39764001da7a080162f85cbc7e"
  sha256_values_array["1.18.19"]="332820433bc7695801bcf6e8444856fc7daae97fc9261b918d491110d67be116"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.32.1"]="98206fd83a4fd17f013f8c61c33d0ae8ec3a7c53ec59ef3d6a0a9400862dc5b2"
  sha256_values_array["1.31.5"]="697c8b4239f9e53cba46296e114bcc02c726b5c7a45e1c464804aad56e5c7a86"
  sha256_values_array["1.30.9"]="bab82f333f6347507a4c725bc726fefd3d862eb64a36a4fb8b99bfe9e10813d0"
  sha256_values_array["1.29.13"]="92a08a9e74efd81be46c9138fce597ab8827e18479fe5cc9c4065659d6464cf1"
  sha256_values_array["1.28.15"]="7d45d9620e67095be41403ed80765fe47fcfbf4b4ed0bf0d1c8fe80345bda7d3"
  sha256_values_array["1.27.16"]="2f50cb29d73f696ffb57437d3e2c95b22c54f019de1dba19e2b834e0b4501eb9"
  sha256_values_array["1.26.15"]="1396313f0f8e84ab1879757797992f1af043e1050283532e0fd8469902632216"
  sha256_values_array["1.25.16"]="d6c23c80828092f028476743638a091f2f5e8141273d5228bf06c6671ef46924"
  sha256_values_array["1.24.17"]="66885bda3a202546778c77f0b66dcf7f576b5a49ff9456acf61329da784a602d"
  sha256_values_array["1.23.17"]="c4a48fdc6038beacbc5de3e4cf6c23639b643e76656aabe2b7798d3898ec7f05"
  sha256_values_array["1.22.17"]="8fc2f8d5c80a6bf60be06f8cf28679a05ce565ce0bc81e70aaac38e0f7da6259"
  sha256_values_array["1.21.14"]="a23151bca5d918e9238546e7af416422b51cda597a22abaae5ca50369abfbbaa"
  sha256_values_array["1.20.15"]="d479febfb2e967bd86240b5c0b841e40e39e1ef610afd6f224281a23318c13dc"
  sha256_values_array["1.19.16"]="6ad55694db34b9ffbc3cb41761a50160eea0a962eb86899410593931b4e602d0"
  sha256_values_array["1.18.19"]="c842438abcb099a5801be3a278f567b73250d293fb98866f9b24e234213be790"

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
