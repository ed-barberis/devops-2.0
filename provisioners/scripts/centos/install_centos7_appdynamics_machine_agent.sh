#!/bin/sh -eux
# install appdynamics machine agent by appdynamics.

# set default values for input environment variables if not set. ---------------
# appd install parameters.
appd_username="${appd_username:-}"                                  # appd account user name.
appd_password="${appd_password:-}"                                  # appd account user password.
appd_home="${appd_home:-/opt/appdynamics}"                          # [optional] appd home (defaults to '/opt/appdynamics').
appd_agent_home="${appd_agent_home:-machine-agent}"                 # [optional] appd agent home (defaults to 'machine-agent').
appd_agent_user="${appd_agent_user:-vagrant}"                       # [optional] appd agent user (defaults to user 'vagrant').
appd_agent_release="${appd_agent_release:-4.5.4.1735}"              # [optional] appd agent release (defaults to '4.5.4.1735').
#
# appd config parameters.
# NOTE: Setting 'appd_config_agent' to 'true' allows you to perform the Machine Agent configuration
#       concurrently with the installation. At a minimum, you must override the 'host' and 'access key'
#       parameters using valid entries for your environment.
#
#       In either case, you will need to validate the configuration before running the Machine Agent.
#       The configuration file can be found here: '<agent_home>/conf/controller-info.xml'
#
appd_config_agent="${appd_config_agent:-false}"                     # [optional] configure appd machine agent boolean (defaults to 'false').
appd_controller_host="${appd_controller_host:-apm}"                 # [optional] appd controller host (defaults to 'apm').
appd_controller_port="${appd_controller_port:-8090}"                # [optional] appd controller port (defaults to '8090').
appd_controller_ssl_enabled="${appd_controller_ssl_enabled:-false}" # [optional] appd controller ssl enabled (defaults to 'false').
appd_enable_orchestration="${appd_enable_orchestration:-false}"     # [optional] appd enable orchestration (defaults to 'false').
appd_unique_host_id="${appd_unique_host_id:-}"                      # [optional] appd unique host id (defaults to '').
appd_sim_enabled="${appd_sim_enabled:-false}"                       # [optional] appd sim enabled (defaults to 'false').
appd_machine_path="${appd_machine_path:-}"                          # [optional] appd machine path (defaults to '').
appd_account_name="${appd_account_name:-customer1}"                 # [optional] appd account name (defaults to 'customer1').
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
    [root]# export appd_agent_home="machine-agent"          # [optional] appd agent home (defaults to 'machine-agent').
    [root]# export appd_agent_user="vagrant"                # [optional] appd agent user (defaults to user 'vagrant').
    [root]# export appd_agent_release="4.5.4.1735"          # [optional] appd agent release (defaults to '4.5.4.1735').
   #
   # appd config parameters.
   # NOTE: Setting 'appd_config_agent' to 'true' allows you to perform the Machine Agent configuration
   #       concurrently with the installation. At a minimum, you must override the 'host' and 'access key'
   #       parameters using valid entries for your environment.
   #
   #       In either case, you will need to validate the configuration before running the Machine Agent.
   #       The configuration file can be found here: '<agent_home>/conf/controller-info.xml'
   #
    [root]# export appd_config_agent="true"                 # [optional] configure appd machine agent boolean (defaults to 'false').
    [root]# export appd_controller_host="apm"               # [optional] appd controller host (defaults to 'apm').
    [root]# export appd_controller_port="8090"              # [optional] appd controller port (defaults to '8090').
    [root]# export appd_controller_ssl_enabled="false"      # [optional] appd controller ssl enabled (defaults to 'false').
    [root]# export appd_enable_orchestration="false"        # [optional] appd enable orchestration (defaults to 'false').
    [root]# export appd_unique_host_id=""                   # [optional] appd unique host id (defaults to '').
    [root]# export appd_sim_enabled="true"                  # [optional] appd sim enabled (defaults to 'false').
    [root]# export appd_machine_path=""                     # [optional] appd machine path (defaults to '').
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

# set appdynamics machine agent installation variables. ------------------------
appd_agent_folder="${appd_agent_home}-${appd_agent_release}"
appd_agent_binary="machineagent-bundle-64bit-linux-${appd_agent_release}.zip"

# create appdynamics machine agent parent folder. ------------------------------
mkdir -p ${appd_home}/${appd_agent_folder}
cd ${appd_home}/${appd_agent_folder}

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# install appdynamics machine agent --------------------------------------------
# authenticate to the appdynamics domain and store the oauth token to a file.
post_data_filename="post-data.${curdate}.json"
oauth_token_filename="oauth-token.${curdate}.json"

rm -f "${post_data_filename}"
touch "${post_data_filename}"
chmod 644 "${post_data_filename}"

echo "{" >> ${post_data_filename}
echo "  \"username\": \"${appd_username}\"," >> ${post_data_filename}
echo "  \"password\": \"${appd_password}\"," >> ${post_data_filename}
echo "  \"scopes\": [\"download\"]" >> ${post_data_filename}
echo "}" >> ${post_data_filename}

curl --silent --request POST --data @${post_data_filename} https://identity.msrv.saas.appdynamics.com/v2.0/oauth/token --output ${oauth_token_filename}
oauth_token=$(awk -F '"' '{print $4}' ${oauth_token_filename})

# download the appdynamics machine agent binary.
rm -f ${appd_agent_binary}
curl --silent --location --remote-name --header "Authorization: Bearer ${oauth_token}" https://download.appdynamics.com/download/prox/download-file/machine-bundle/${appd_agent_release}/${appd_agent_binary}
chmod 644 ${appd_agent_binary}

rm -f ${post_data_filename}
rm -f ${oauth_token_filename}

# extract appdynamics machine agent binary.
unzip ${appd_agent_binary}
rm -f ${appd_agent_binary}
cd ${appd_home}
rm -f ${appd_agent_home}
ln -s ${appd_agent_folder} ${appd_agent_home}
chown -R ${appd_agent_user}:${appd_agent_user} .

# configure appdynamics machine agent ------------------------------------------
if [ "$appd_config_agent" == "true" ]; then
  appd_agent_config_file="controller-info.xml"
  cd ${appd_home}/${appd_agent_folder}/conf
  cp -p ${appd_agent_config_file} ${appd_agent_config_file}.orig

  sed -i -e "s/<controller-host>/<controller-host>${appd_controller_host}/g" ${appd_agent_config_file}
  sed -i -e "s/<controller-port>/<controller-port>${appd_controller_port}/g" ${appd_agent_config_file}
  sed -i -e "/^    <controller-ssl-enabled>/s/^.*$/    <controller-ssl-enabled>${appd_controller_ssl_enabled}<\/controller-ssl-enabled>/" ${appd_agent_config_file}
  sed -i -e "/^    <enable-orchestration>/s/^.*$/    <enable-orchestration>${appd_enable_orchestration}<\/enable-orchestration>/" ${appd_agent_config_file}
  sed -i -e "s/<unique-host-id>/<unique-host-id>${appd_unique_host_id}/g" ${appd_agent_config_file}
  sed -i -e "s/<account-access-key>/<account-access-key>${appd_account_access_key}/g" ${appd_agent_config_file}
  sed -i -e "s/<account-name>/<account-name>${appd_account_name}/g" ${appd_agent_config_file}
  sed -i -e "/^    <sim-enabled>/s/^.*$/    <sim-enabled>${appd_sim_enabled}<\/sim-enabled>/" ${appd_agent_config_file}
  sed -i -e "s/<machine-path>/<machine-path>${appd_machine_path}/g" ${appd_agent_config_file}
fi

# configure the appdynamics machine agent as a service. ------------------------
systemd_dir="/etc/systemd/system"
appd_machine_agent_service="appdynamics-machine-agent.service"
service_filepath="${systemd_dir}/${appd_machine_agent_service}"

pid_dir="/var/run/appdynamics"
pid_file="appdynamics-machine-agent.pid"

# create systemd service file.
if [ -d "$systemd_dir" ]; then
  rm -f "${service_filepath}"

  touch "${service_filepath}"
  chmod 644 "${service_filepath}"

  echo "[Unit]" >> "${service_filepath}"
  echo "Description=AppDynamics Machine Agent" >> "${service_filepath}"
  echo "After=network.target remote-fs.target nss-lookup.target" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "[Service]" >> "${service_filepath}"
  echo "# The machine agent startup script does not fork a process, so this is a simple service." >> "${service_filepath}"
  echo "Type=simple" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "Environment=MACHINE_AGENT_HOME=${appd_home}/${appd_agent_home}" >> "${service_filepath}"
  echo "Environment=JAVA_HOME=${appd_home}/${appd_agent_home}/jre" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "# Specify the 'user' to run the machine agent as." >> "${service_filepath}"
  echo "User=${appd_agent_user}" >> "${service_filepath}"
  echo "Environment=MACHINE_AGENT_USER=${appd_agent_user}" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "Environment=PIDDIR=${pid_dir}" >> "${service_filepath}"
  echo "Environment=PIDFILE=\${PIDDIR}/${pid_file}" >> "${service_filepath}"
  echo "PIDFile=${pid_dir}/${pid_file}" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "# Killing the service using systemd causes Java to exit with status 143. This is OK." >> "${service_filepath}"
  echo "SuccessExitStatus=143" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "# Run ExecStartPre with root-permissions." >> "${service_filepath}"
  echo "PermissionsStartOnly=true" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "ExecStartPre=/usr/bin/install -o \${MACHINE_AGENT_USER} -d \${PIDDIR}" >> "${service_filepath}"
  echo "ExecStart=/bin/sh -c \${MACHINE_AGENT_HOME}/bin/machine-agent -d -p \${PIDFILE}" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "[Install]" >> "${service_filepath}"
  echo "WantedBy=multi-user.target" >> "${service_filepath}"
fi

# reload systemd manager configuration.
systemctl daemon-reload

# enable the machine agent service to start at boot time.
systemctl enable "${appd_machine_agent_service}"
systemctl is-enabled "${appd_machine_agent_service}"

# check current status.
#systemctl status "${appd_machine_agent_service}"
