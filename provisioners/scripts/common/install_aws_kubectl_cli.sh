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
kubectl_release="1.34.2"
kubectl_date="2025-11-13"
#kubectl_release="1.33.5"
#kubectl_date="2025-11-13"
#kubectl_release="1.32.9"
#kubectl_date="2025-11-13"
#kubectl_release="1.31.13"
#kubectl_date="2025-11-13"
#kubectl_release="1.30.14"
#kubectl_date="2025-11-13"
#kubectl_release="1.29.15"
#kubectl_date="2025-11-13"
#kubectl_release="1.28.15"
#kubectl_date="2025-11-13"
#kubectl_release="1.27.16"
#kubectl_date="2024-12-12"
#kubectl_release="1.26.15"
#kubectl_date="2024-12-12"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.34.2"]="749e3e6b0fce233a86ea5600b99af85a27f68c77b92175c4c72a630cdce38c5c"
  sha256_values_array["1.33.5"]="c53376575a51d81007e42cff3f072a7d844b17aa10be7e1c4bd5182ea913b617"
  sha256_values_array["1.32.9"]="ffe522e733118416f85b0d18e65066621bb4bd6af43c47a721cee154786cada7"
  sha256_values_array["1.31.13"]="a24d2160e598652a5abda0b77472d3171cda1f3c6b40eda4bb2ec30a27f9ef91"
  sha256_values_array["1.30.14"]="33d329c7bbe97280a4ec8796edc9eac89ee8aedaeda04176b8a5cbfba981205f"
  sha256_values_array["1.29.15"]="a44fd74e56bf4cabb96fb73130d17136fcbf19258a08a5ab736277b24531aa93"
  sha256_values_array["1.28.15"]="a01319713d23f70e8142f7a2a4db879947e7192802223bb6a72e392370cffae4"
  sha256_values_array["1.27.16"]="1813737d0997f372a1be2da6897a638e2a7eb81e5f828e0e0e724f05c50256aa"
  sha256_values_array["1.26.15"]="4dea29aaca9314d089bd8b1829f9c3dec02618c2e44064e92271559175811e24"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.34.2"]="4b1879fba004e9389d3897bad3e2ae658c70d48afa9f8d1fe67bf49945de4748"
  sha256_values_array["1.33.5"]="1dbd9b5bedadec945c45310d3e7a4289e9a0ad67ff8fc0637a5a909490c83810"
  sha256_values_array["1.32.9"]="aba4c279d4ba74fa80e4ef19e561aac72580705a6c8fb1f2f75633c4b61bd543"
  sha256_values_array["1.31.13"]="b4a3cf46653eb00550f417f7dc5f1529a147030a5f0dba281afb876ad5ae68a5"
  sha256_values_array["1.30.14"]="9719322263496c4b251d6ab8bfc06d544beae27dc517a570c22f3a566e467dc0"
  sha256_values_array["1.29.15"]="7fd722635294b0fd5912bed707ec409c1d2af2104add1f1eeda10a48d038842e"
  sha256_values_array["1.28.15"]="3d6f63abb4bc6d9035c926a0b29269ce0a2e8a2501dceb452732adf524b9830b"
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
