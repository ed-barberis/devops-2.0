#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Terraform Infrastructure as Code Tool by HashiCorp.
#
# Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently.
# Terraform can manage existing and popular service providers as well as custom in-house solutions.
#
# Configuration files describe to Terraform the components needed to run a single application or
# your entire datacenter. Terraform generates an execution plan describing what it will do to
# reach the desired state, and then executes it to build the described infrastructure. As the
# configuration changes, Terraform is able to determine what changed and create incremental
# execution plans which can be applied.
#
# The infrastructure Terraform can manage includes low-level components such as compute instances,
# storage, and networking, as well as high-level components such as DNS entries, SaaS features,
# etc.
#
# The key features of Terraform are:
# - Infrastructure as Code
# - Execution Plans
# - Resource Graph
# - Change Automation
#
# For more details, please visit:
#   https://terraform.io/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install hashicorp terraform. ---------------------------------------------------------------------
terraform_release="1.11.0"

# set the terraform cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  terraform_binary="terraform_${terraform_release}_linux_amd64.zip"
  terraform_sha256="069e531fd4651b9b510adbd7e27dd648b88d66d5f369a2059aadbb4baaead1c1"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  terraform_binary="terraform_${terraform_release}_linux_arm64.zip"
  terraform_sha256="0a7e88cbb431044a16335369f850359def93b2898adc1778063784760db69093"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download terraform binary from hashicorp.com.
rm -f ${terraform_binary}
wget --no-verbose https://releases.hashicorp.com/terraform/${terraform_release}/${terraform_binary}

# verify the downloaded binary.
echo "${terraform_sha256} ${terraform_binary}" | sha256sum --check
# terraform_${terraform_release}_linux_amd64.zip: OK
# terraform_${terraform_release}_linux_arm64.zip: OK

# extract terraform binary and license.
rm -f terraform LICENSE.txt
unzip ${terraform_binary} terraform
chmod 755 terraform
rm -f ${terraform_binary}

# verify installation. -----------------------------------------------------------------------------
# set terraform environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify terraform version.
terraform version
