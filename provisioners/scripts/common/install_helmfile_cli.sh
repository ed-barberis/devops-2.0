#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Helmfile CLI package manager for Kubernetes.
#
# Helmfile is a declarative spec for deploying helm charts. It lets you:
#
# - Keep a directory of chart value files and maintain changes in version control.
# - Apply CI/CD to configuration changes.
# - Periodically sync to avoid skew in environments.
#
# To avoid upgrades for each iteration of 'helm', the 'helmfile' executable delegates to helm. As
# a result, 'helm' must be installed.
#
# For more details, please visit:
#   https://github.com/helmfile/helmfile
#   https://helmfile.readthedocs.io/en/stable/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] helmfile install parameters [w/ defaults].
#####user_name="${user_name:-centos}"

# install helmfile cli client. ---------------------------------------------------------------------
helmfile_release="0.169.1"
helmfile_binary="helmfile_${helmfile_release}_linux_amd64.tar.gz"
helmfile_sha256="c3c18ad2fbc83a5440f09f79a9dfa8df2a288595766655fe79b34dd902ba8c6d"

# check if 'helm' is installed. --------------------------------------------------------------------
if [ ! -f "/usr/local/bin/helm" ] && [ ! -f "/opt/homebrew/bin/helm" ]; then
  set +x  # temporarily turn command display OFF.
  echo "Error: 'helm' command-line utility not found."
  echo "NOTE: This script requires the 'helm' command-line utility."
  echo "      For more information, visit: https://helm.sh/"
  set -x  # turn command display back ON.
  exit 1
fi

# check if 'helm' command-line utility is installed. -----------------------------------------------
#####path_to_helm=$(runuser -c "which helm" - ${user_name})
#####if [ ! -x "$path_to_helm" ] ; then
#####  set +x  # temporarily turn command display OFF.
#####  echo "Error: 'helm' command-line utility not found."
#####  echo "NOTE: This script requires the 'helm' command-line utility."
#####  echo "      For more information, visit: https://helm.sh/"
#####  set -x  # turn command display back ON.
#####  exit 1
#####fi

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download helmfile from github.com.
rm -f ${helmfile_binary}
curl --silent --location "https://github.com/helmfile/helmfile/releases/download/v${helmfile_release}/${helmfile_binary}" --output ${helmfile_binary}
chmod 755 ${helmfile_binary}

# verify the downloaded binary.
echo "${helmfile_sha256} ${helmfile_binary}" | sha256sum --check
# helmfile_${helmfile_release}_linux_amd64.tar.gz: OK

# extract helmfile cli binary.
rm -f helmfile
tar -zxvf ${helmfile_binary} --no-same-owner --no-overwrite-dir helmfile
chown root:root helmfile
rm -f ${helmfile_binary}

# change execute permissions.
chmod 755 helmfile

# set helm environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation. -----------------------------------------------------------------------------
helmfile --version
