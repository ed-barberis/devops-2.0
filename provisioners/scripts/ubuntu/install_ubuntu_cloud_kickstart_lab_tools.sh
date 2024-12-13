#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install Cloud Kickstart Lab tools on Ubuntu linux 64-bit.
#
# To configure the Cloud Kickstart Lab workshop environments, the first step is to set-up your
# development environment by installing the needed software. This script simplifies that process
# by automating the installation of all needed packages.
#
# For Ubuntu, these software utilities include the following:
#   Git:        Git is a distributed version control system.
#   Packer:     Packer is a machine and container image tool by HashiCorp.
#   Terraform:  Terraform is an Infrastructure as Code (IaC) tool by HashiCorp.
#   jq:         jq is a command-line json processor for linux 64-bit.
#   AWS CLI v2: AWS CLI is an open source tool that enables you to interact with AWS services.
#
# For more details, please visit:
#   https://git-scm.com/
#   https://packer.io/
#   https://terraform.io/
#   https://stedolan.github.io/jq/
#   https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
#
# NOTE: Script should be run as the installed user with 'sudo' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
user_name="$(whoami)"                                       # current user name.
export user_name
user_group="$(groups | awk '{print $1}')"                   # current user group name.
export user_group
user_home="$(eval echo "~${user_name}")"                    # current user home folder.
export user_home
devops_home="${user_home}/devops-2.0"                       # devops lab home folder.
export devops_home

# validate environment variables. ------------------------------------------------------------------
if [ "$user_name" = "root" ]; then
  echo "Error: 'user_name' should NOT be 'root'."
  exit 1
fi

# install basic utilities needed for the install scripts. ------------------------------------------
# update apt repository package indexes for ubuntu.
DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND
sudo apt-get update
sudo apt-get -y upgrade

# install core linux utilities.
sudo apt-get -y install curl git tree wget unzip man

# download the devops lab project from github.com. -------------------------------------------------
cd ${user_home}
rm -Rf ${devops_home}
git clone https://github.com/ed-barberis/devops-2.0.git ${devops_home}
cd ${devops_home}
git fetch origin

# download and install the custom utilities. -------------------------------------------------------
# download, build, and install git from source.
cd ${devops_home}/provisioners/scripts/ubuntu
sudo -E ./install_ubuntu_git.sh

# download and install packer by hashicorp.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_hashicorp_packer.sh

# download and install terraform by hashicorp.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_hashicorp_terraform.sh

# download and install jq json processor.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_jq_json_processor.sh

# download and install aws command line interface (cli) 2 by amazon.
cd ${devops_home}/provisioners/scripts/common
sudo -E ./install_aws_cli_2.sh

# download, build, and install vim 9 text editor from source.
cd ${devops_home}/provisioners/scripts/ubuntu
sudo ./install_ubuntu_vim_9.sh

# create default command-line environment profile for the 'root' user.
cd ${devops_home}/provisioners/scripts/common
sudo runuser -c "touch ~/.bash_profile" - root
sudo runuser -c "touch ~/.bashrc" - root
sudo -E runuser -c "TERM=xterm-256color devops_home=${devops_home} ${devops_home}/provisioners/scripts/common/install_headless_root_user_env.sh" - root

# use the stream editor to update the correct 'devops_home'.
sudo -E runuser -c "devops_home=${devops_home} sed -i -e \"/^devops_home/c\devops_home=\"${devops_home}\"\" ~/.bashrc" - root

# create default command-line environment profile for the current user.
cd ${devops_home}/provisioners/scripts/common
touch ~/.bash_profile
touch ~/.bashrc
sudo -E ./install_headless_user_env.sh

# use the stream editor to update the correct 'devops_home'.
#sed -i -e "/^devops_home/c\devops_home=\"${devops_home}\"" ~/.bashrc

# change ownership of any 'root' owned files and folders.
cd ${user_home}
sudo chown -R ${user_name}:${user_group} .

# verify installations. ----------------------------------------------------------------------------
# set environment variables.
GIT_HOME=/usr/local/git/git
export GIT_HOME
PATH=${GIT_HOME}/bin:/usr/local/bin:$PATH
export PATH

# verify basic utility installations.
curl --version
tree --version
wget --version
unzip -v

# verify custom utility installations.
git --version
packer --version
terraform --version
jq --version
aws --version
vim --version | awk 'FNR < 3 {print $0}'

# unset user environment variables. ----------------------------------------------------------------
unset user_name
unset user_group
unset user_home
unset devops_home

# print completion message.
echo "Cloud Kickstart Lab Tools installation complete."
