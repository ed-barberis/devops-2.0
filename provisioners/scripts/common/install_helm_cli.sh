#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Helm CLI package manager for Kubernetes.
#
# Helm is a tool that streamlines installing and managing Kubernetes applications.
# Think of it like apt/yum/homebrew for Kubernetes.
#
# - Helm runs on your laptop, CI/CD, or wherever you want it to run.
# - Charts are Helm packages that contain at least two things:
#   - A description of the package (`Chart.yaml`)
#   - One or more templates, which contain Kubernetes manifest files
# - Charts can be stored on disk, or fetched from remote chart repositories
#   (like Debian or RedHat packages)
#
# For more details, please visit:
#   https://helm.sh
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install helm cli client. -------------------------------------------------------------------------
helm_release="3.16.2"

# set the helm cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  helm_folder="linux-amd64"
  helm_binary="helm-v${helm_release}-linux-amd64.tar.gz"
  helm_sha256="9318379b847e333460d33d291d4c088156299a26cd93d570a7f5d0c36e50b5bb"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  helm_folder="linux-arm64"
  helm_binary="helm-v${helm_release}-linux-arm64.tar.gz"
  helm_sha256="1888301aeb7d08a03b6d9f4d2b73dcd09b89c41577e80e3455c113629fc657a4"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download helm from github.com.
rm -f ${helm_binary}
rm -Rf ${helm_folder}
curl --silent --location "https://get.helm.sh/${helm_binary}" --output ${helm_binary}
chmod 755 ${helm_binary}

# verify the downloaded binary.
echo "${helm_sha256} ${helm_binary}" | sha256sum --check
# helm-${helm_release}-linux-amd64.tar.gz: OK

# extract helm binaries.
rm -f helm
tar -zxvf ${helm_binary} --no-same-owner --no-overwrite-dir
chown root:root ${helm_folder}
cp ./${helm_folder}/helm .
rm -f ${helm_binary}
rm -Rf ${helm_folder}

# change execute permissions.
chmod 755 helm

# set helm environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation. -----------------------------------------------------------------------------
helm version --short --client

# initialize a helm chart repository.
helm repo add stable https://charts.helm.sh/stable

# list charts we can install.
#helm search repo stable

# install an example chart.
# make sure we get the latest list of charts.
#helm repo update
#helm install stable/mysql --generate-name
