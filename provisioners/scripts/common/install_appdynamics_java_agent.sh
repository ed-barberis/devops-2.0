#!/bin/sh -eux
# install appdynamics java agent by appdynamics.

# set default values for input environment variables if not set. ---------------
# appd install parameters.
appd_username="${appd_username:-}"                          # appd account user name.
appd_password="${appd_password:-}"                          # appd account user password.
appd_home="${appd_home:-/opt/appdynamics}"                  # [optional] appd home (defaults to '/opt/appdynamics').
appd_agent_home="${appd_agent_home:-appagent}"              # [optional] appd agent home (defaults to 'appagent').
appd_agent_user="${appd_agent_user:-vagrant}"               # [optional] appd agent user (defaults to user 'vagrant').
appd_agent_release="${appd_agent_release:-4.4.2.22394}"     # [optional] appd agent release (defaults to '4.4.2.22394').
#
# appd config parameters.
# NOTE: Setting 'appd_config_agent' to 'true' allows you to perform the Java Agent configuration
#       concurrently with the installation. At a minimum, you must override the 'host' and 'access key'
#       parameters using valid entries for your environment.
#
#       In either case, you will need to validate the configuration before running the Java Agent.
#       The configuration file can be found here: '<agent_home>/conf/controller-info.xml'
#
appd_config_agent="${appd_config_agent:-false}"             # [optional] configure appd java agent boolean (defaults to 'false').
appd_controller_host="${appd_controller_host:-apm}"         # [optional] appd controller host (defaults to 'apm').
appd_controller_port="${appd_controller_port:-8090}"        # [optional] appd controller port (defaults to '8090').
appd_application_name="${appd_application_name:-My App}"    # [optional] appd application name (such as 'My App').
appd_tier_name="${appd_tier_name:-My App Web Tier}"         # [optional] appd tier name (such as 'My App Web Tier').
appd_node_name="${appd_node_name:-Development}"             # [optional] appd node name (such as 'Development').
appd_account_name="${appd_account_name:-customer1}"         # [optional] appd account name (defaults to 'customer1').
                                                            # [optional] appd account access key.
appd_account_access_key="${appd_account_access_key:-abcdef01-2345-6789-abcd-ef0123456789}"

# define usage function. -------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
   # appd install parameters.
    [root]# export appd_username="name@example.com"         # appd account user name.
    [root]# export appd_password="password"                 # appd account user password.
    [root]# export appd_home="/opt/appdynamics"             # [optional] appd home (defaults to '/opt/appdynamics').
    [root]# export appd_agent_home="appagent"               # [optional] appd agent home (defaults to 'appagent').
    [root]# export appd_agent_user="vagrant"                # [optional] appd agent user (defaults to user 'vagrant').
    [root]# export appd_agent_release="4.4.2.22394"         # [optional] appd agent release (defaults to '4.4.2.22394').
   #
   # appd config parameters.
   # NOTE: Setting 'appd_config_agent' to 'true' allows you to perform the Java Agent configuration
   #       concurrently with the installation. At a minimum, you must override the 'host' and 'access key'
   #       parameters using valid entries for your environment.
   #
   #       In either case, you will need to validate the configuration before running the Java Agent.
   #       The configuration file can be found here: '<agent_home>/conf/controller-info.xml'
   #
    [root]# export appd_config_agent="true"                 # [optional] configure appd java agent boolean (defaults to 'false').
    [root]# export appd_controller_host="apm"               # [optional] appd controller host (defaults to 'apm').
    [root]# export appd_controller_port="8090"              # [optional] appd controller port (defaults to '8090').
    [root]# export appd_application_name="My App"           # [optional] appd application name (such as 'My App').
    [root]# export appd_tier_name="My App Web Tier"         # [optional] appd tier name (such as 'My App Web Tier').
    [root]# export appd_node_name="Development"             # [optional] appd node name (such as 'Development').
    [root]# export appd_account_name="customer1"            # [optional] appd account name (defaults to 'customer1').
                                                            # [optional] appd account access key.
    [root]# export appd_account_access_key="abcdef01-2345-6789-abcd-ef0123456789"
    [root]# $0
EOF
}

# validate environment variables. ----------------------------------------------
if [ -z "$appd_username" ]; then
  echo "Error: 'appd_username' environment variable not set."
  usage
  exit 1
fi

if [ -z "$appd_password" ]; then
  echo "Error: 'appd_password' environment variable not set."
  usage
  exit 1
fi

# set appdynamics java agent installation variables. ---------------------------
appd_agent_folder="${appd_agent_home}-${appd_agent_release}"
appd_agent_binary="AppServerAgent-${appd_agent_release}.zip"

# create appdynamics java agent parent folder. ---------------------------------
mkdir -p ${appd_home}/${appd_agent_folder}
cd ${appd_home}/${appd_agent_folder}

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# install appdynamics java agent -----------------------------------------------
# authenticate to the appdynamics domain and store session id in a file.
curl --silent --cookie-jar cookies-${curdate}.txt --data "username=${appd_username}&password=${appd_password}" https://login.appdynamics.com/sso/login/

# download the appdynamics java agent binary.
curl --silent --location --remote-name --cookie cookies-${curdate}.txt https://download.appdynamics.com/download/prox/download-file/sun-jvm/${appd_agent_release}/${appd_agent_binary}
chmod 644 ${appd_agent_binary}

rm -f cookies-${curdate}.txt

# extract appdynamics java agent binary.
rm -f ${appd_agent_home}
unzip ${appd_agent_binary}
rm -f ${appd_agent_binary}
cd ${appd_home}
ln -s ${appd_agent_folder} ${appd_agent_home}
chown -R ${appd_agent_user}:${appd_agent_user} .

# configure appdynamics java agent ---------------------------------------------
if [ "$appd_config_agent" == "true" ]; then
  appd_agent_config_file="controller-info.xml"
  cd ${appd_home}/${appd_agent_folder}/conf
  cp -p ${appd_agent_config_file} ${appd_agent_config_file}.orig

  sed -i -e "s/<controller-host>/<controller-host>${appd_controller_host}/g" ${appd_agent_config_file}
  sed -i -e "s/<controller-port>/<controller-port>${appd_controller_port}/g" ${appd_agent_config_file}
  sed -i -e "s/<application-name>/<application-name>${appd_application_name}/g" ${appd_agent_config_file}
  sed -i -e "s/<tier-name>/<tier-name>${appd_tier_name}/g" ${appd_agent_config_file}
  sed -i -e "s/<node-name>/<node-name>${appd_node_name}/g" ${appd_agent_config_file}
  sed -i -e "s/<account-name>/<account-name>${appd_account_name}/g" ${appd_agent_config_file}
  sed -i -e "s/<account-access-key>/<account-access-key>${appd_account_access_key}/g" ${appd_agent_config_file}
fi
