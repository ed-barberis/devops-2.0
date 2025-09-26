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
#kubectl_release="1.34.1"
#kubectl_date="2025-09-19"
kubectl_release="1.33.5"
kubectl_date="2025-09-19"
#kubectl_release="1.32.9"
#kubectl_date="2025-09-19"
#kubectl_release="1.31.13"
#kubectl_date="2025-09-19"
#kubectl_release="1.30.14"
#kubectl_date="2025-09-19"
#kubectl_release="1.29.15"
#kubectl_date="2025-09-19"
#kubectl_release="1.28.15"
#kubectl_date="2025-09-19"
#kubectl_release="1.27.16"
#kubectl_date="2024-12-12"
#kubectl_release="1.26.15"
#kubectl_date="2024-12-12"

# declare associative array for the sha256 values.
declare -A sha256_values_array

# set the kubectl cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 sha256 values.
  sha256_values_array["1.34.1"]="abf9acae546a5cf8c70d703b2c862dfb39406e83cfc62747589c5e7de2395987"
  sha256_values_array["1.33.5"]="e1f6976fa8d1a2e6982b88129d1569503cda2dbea9409e362e6645ceaf27c5a0"
  sha256_values_array["1.32.9"]="8188043d4cfb3b80716cf620db114e27af183f6abe66ccb422d2b9dfe8e1a25c"
  sha256_values_array["1.31.13"]="60d2f125a3a4d4777e312068fa5128a3109e5c78f63d04ad914efd22742ee729"
  sha256_values_array["1.30.14"]="52bed54573606a1b5ccca9a640db6e8ea8e610cb6a734899c9be0695e0afca8c"
  sha256_values_array["1.29.15"]="1d0094df5f4af2cc6f2eb57f4b0d56b24b2f7f315537cb0cc50206ec2bc08b58"
  sha256_values_array["1.28.15"]="fa6e3c780be154477d53b26ffedffc63442ea7eff67dd318c02c9fc87a24f4f2"
  sha256_values_array["1.27.16"]="1813737d0997f372a1be2da6897a638e2a7eb81e5f828e0e0e724f05c50256aa"
  sha256_values_array["1.26.15"]="4dea29aaca9314d089bd8b1829f9c3dec02618c2e44064e92271559175811e24"

  # set the amd64 download path.
  kubectl_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 sha256 values.
  sha256_values_array["1.34.1"]="b4567ed6ca930409d85ac0fd57bd95fe3956ff107b51281c47adf71e2fb0db57"
  sha256_values_array["1.33.5"]="2796ba6ea0f17b94c6fd6cb64891bbcf8d8fd9a69d67d9c459e84f50407b58c3"
  sha256_values_array["1.32.9"]="a2356a4ca73a7da38fac1e748c1b4adb20d4213cd9c4b1b33a7658b9999bfd78"
  sha256_values_array["1.31.13"]="947b30e6e8588fe62bf164915e481a3a70eb45646d740d7f93d04c832e63ac13"
  sha256_values_array["1.30.14"]="3ac39d8ccdb8ca556b312bda7e5456fe65cce0c56da31e559911ea5f33924d1e"
  sha256_values_array["1.29.15"]="7a00e813614318937f1c24f6ff41cfa62968c5a1a050ab762b3bf30f0813ebbe"
  sha256_values_array["1.28.15"]="64cd5a37f93b5222559858a34580e5a48b00bede6385f719d7fca0a613c181a6"
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
