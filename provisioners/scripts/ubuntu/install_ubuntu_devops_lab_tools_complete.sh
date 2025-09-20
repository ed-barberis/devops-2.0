#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install DevOps 2.0 Lab tools on Ubuntu linux 64-bit.
#
# To configure the DevOps 2.0 Lab environments, the first step is to set-up your development
# environment by installing the needed software. This script simplifies that process by automating
# the installation of all needed packages.
#
# For Ubuntu, these software utilities include the following:
#   Git:        Git is a distributed version control system.
#   Packer:     Packer is a machine and container image tool by HashiCorp.
#   Terraform:  Terraform is an Infrastructure as Code (IaC) tool by HashiCorp.
#   jq:         jq is a command-line json processor for linux 64-bit.
#   AWS CLI v2: AWS CLI is an open source tool that enables you to interact with AWS services.
#
# To install, run:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ed-barberis/devops-2.0/refs/heads/master/provisioners/scripts/ubuntu/install_ubuntu_devops_lab_tools_complete.sh)"
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
DEBIAN_FRONTEND=noninteractive                              # set non-interactive mode.
export DEBIAN_FRONTEND
tomcat_username="${user_name}"
export tomcat_username
tomcat_group="${user_group}"
export tomcat_group

# validate environment variables. ------------------------------------------------------------------
if [ "$user_name" = "root" ]; then
  echo "Error: 'user_name' should NOT be 'root'."
  exit 1
fi

# install basic utilities needed for the install scripts. ------------------------------------------
# update apt repository package indexes for ubuntu.
sudo -E apt-get update
sudo -E apt-get -y upgrade
sudo hostnamectl | awk '/Operating System/ {print $0}'

# install core linux utilities.
sudo -E apt-get -y install curl git tree wget unzip man net-tools debconf-utils

# download the devops lab project from github.com. -------------------------------------------------
cd ${user_home}
rm -Rf ${devops_home}
git clone https://github.com/ed-barberis/devops-2.0.git ${devops_home}
cd ${devops_home}
git fetch origin

# download and install the custom utilities. -------------------------------------------------------
# retrieve ubuntu release version.
ubuntu_release=$(lsb_release -rs)

# download, build, and install git from source.
cd ${devops_home}/provisioners/scripts/ubuntu
sudo -E ./install_ubuntu_git.sh

cd ${devops_home}/provisioners/scripts/common
sudo -E ./install_git_flow.sh

# download and install hashicorp tools.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_hashicorp_consul.sh
sudo ./install_hashicorp_packer.sh
sudo ./install_hashicorp_terraform.sh
sudo ./install_hashicorp_vault.sh

# download and install cli processors.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_jq_json_processor.sh
sudo ./install_yq_yaml_processor.sh
sudo ./install_jmespath_jp_json_processor.sh

cd ${devops_home}/provisioners/scripts/ubuntu
sudo -E ./install_ubuntu_xmlstarlet_xml_processor.sh

# download and install aws command line interface (cli) 2 by amazon.
cd ${devops_home}/provisioners/scripts/common
sudo -E ./install_aws_cli_2.sh

# download, build, and install vim 9 text editor from source.
cd ${devops_home}/provisioners/scripts/ubuntu
sudo -E ./install_ubuntu_vim_9.sh

# install latest python and ubuntu core linux utilities.
cd ${devops_home}/provisioners/scripts/ubuntu
sudo -E ./install_ubuntu_devops_tools.sh

# download and install amazon corretto openjdks by amazon.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_aws_corretto_java_jdk_8.sh
sudo ./install_aws_corretto_java_jdk_11.sh
sudo ./install_aws_corretto_java_jdk_17.sh
sudo ./install_aws_corretto_java_jdk_21.sh
sudo ./install_aws_corretto_java_jdk_25.sh

# handle ubuntu release-specific installations.
if [ -n "$ubuntu_release" ]; then
  case $ubuntu_release in
    20.04|22.04)
      # install python3 on ubuntu linux.
      cd ${devops_home}/provisioners/scripts/ubuntu
      sudo -E ./install_ubuntu_python3.sh

      # install ansible with python3 for linux.
      cd ${devops_home}/provisioners/scripts/common
      sudo -E ./install_ansible.sh
      ;;

    24.04|25.04)
      # install ansible on ubuntu linux.
      cd ${devops_home}/provisioners/scripts/ubuntu
      sudo -E ./install_ubuntu_ansible.sh
      ;;

    *)
      ;;
  esac
fi

# download and install the docker engine on ubuntu linux.
cd ${devops_home}/provisioners/scripts/ubuntu
sudo -E ./install_ubuntu_docker.sh

# download and install docker compose v2 on linux x86 64-bit.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_docker_compose_2.sh

# download and install appdynamics ansible collection for agent management.
cd ${devops_home}/provisioners/scripts/common
sudo -E ./install_appdynamics_ansible_collection.sh

# download and install system information tools.
cd ${devops_home}/provisioners/scripts/ubuntu
sudo -E ./install_ubuntu_neofetch_repo.sh

cd ${devops_home}/provisioners/scripts/common
sudo ./install_fastfetch_cli.sh

# download and install kubernetes tools.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_aws_eksctl_cli.sh
#sudo ./install_aws_kubectl_cli.sh
sudo ./install_kubectl_cli.sh
sudo ./install_k9s_cli.sh
sudo ./install_helm_cli.sh
sudo -E ./install_helmfile_cli.sh
sudo ./install_jsonnet_bundler_package_manager.sh
sudo -E ./install_grafana_tanka_cli.sh

# download and install developer build tools.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_apache_ant.sh
sudo ./install_apache_maven.sh
sudo ./install_apache_groovy.sh
sudo ./install_gradle.sh

# download and install go programming language from google.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_google_golang.sh

# download and install rust programming language and onefetch cli tool.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_rust.sh
sudo ./install_onefetch_cli.sh

# download and install scala programming language utilities.
cd ${devops_home}/provisioners/scripts/common
sudo ./install_scala3_lang.sh
sudo ./install_scala_sbt.sh

# download and install node.js developer tools.
cd ${devops_home}/provisioners/scripts/common
sudo -E ./install_nodejs_javascript_runtime.sh
sudo -E ./install_serverless_framework_cli.sh

# download and install mongodb community server 7.0 on ubuntu linux.
cd ${devops_home}/provisioners/scripts/ubuntu
sudo -E ./install_ubuntu_mongodb_community_server_7.sh

# download and install apache tomcat 10.1.x web server by apache on ubuntu linux.
cd ${devops_home}/provisioners/scripts/centos
sudo -E ./install_centos7_apache_tomcat_10_1.sh

# download and install mysql community server 8.4 lts by oracle on ubuntu linux.
cd ${devops_home}/provisioners/scripts/ubuntu
sudo -E ./install_ubuntu_oracle_mysql_community_server_84.sh

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
sed -i -e "/^devops_home/c\devops_home=\"${devops_home}\"" ~/.bashrc

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
unset DEBIAN_FRONTEND
unset tomcat_username
unset tomcat_group

# print completion message.
echo "DevOps 2.0 Lab Tools installation complete."
