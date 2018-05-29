#!/bin/sh -eux
# install appdynamics enterprise console by appdynamics.

# set local installation variables. --------------------------------------------
local_hostname="$(uname -n)"                                # initialize hostname.

# set default values for input environment variables if not set. ---------------
# appd platform install parameters.
appd_username="${appd_username:-}"                          # appd account user name.
appd_password="${appd_password:-}"                          # appd account user password.
appd_home="${appd_home:-/opt/appdynamics}"                  # [optional] appd home (defaults to '/opt/appdynamics').
appd_platform_home="${appd_platform_home:-platform}"        # [optional] appd platform home (defaults to 'platform').
appd_platform_rel="${appd_platform_rel:-4.4.3.10393}"       # [optional] appd platform release (defaults to '4.4.3.10393').

appd_admin_username="${appd_admin_username:-admin}"         # [optional] appd admin user name (defaults to user 'admin').
appd_admin_password="${appd_admin_password:-welcome1}"      # [optional] appd admin password (defaults to 'welcome1').
appd_db_password="${appd_db_password:-welcome1}"            # [optional] appd database password (defaults to 'welcome1').
appd_db_root_password="${appd_db_root_password:-welcome1}"  # [optional] appd database root password (defaults to 'welcome1').
appd_server_host="${appd_server_host:-$local_hostname}"     # [optional] appd hostname (defaults to 'uname -n').
appd_server_port="${appd_server_port:-9191}"                # [optional] appd server port (defaults to '9191').

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# define usage function. -------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
   # appd platform install parameters.
    [root]# export appd_username="name@example.com"         # appd account user name.
    [root]# export appd_password="password"                 # appd account user password.
    [root]# export appd_home="/opt/appdynamics"             # [optional] appd home (defaults to '/opt/appdynamics').
    [root]# export appd_platform_home="platform"            # [optional] appd platform home (defaults to 'platform').
    [root]# export appd_platform_rel="4.4.3.10393"          # [optional] appd platform release (defaults to '4.4.3.10393').
   #
    [root]# export appd_admin_username="admin"              # [optional] appd admin user name (defaults to user 'admin').
    [root]# export appd_admin_password="welcome1"           # [optional] appd admin password (defaults to 'welcome1').
    [root]# export appd_db_password="welcome1"              # [optional] appd database password (defaults to 'welcome1').
    [root]# export appd_db_root_password="welcome1"         # [optional] appd database root password (defaults to 'welcome1').
    [root]# export appd_server_host="apm"                   # [optional] appd hostname (defaults to 'uname -n').
    [root]# export appd_server_port="9191"                  # [optional] appd server port (defaults to '9191').
   #
    [root]# export devops_home="/opt/devops"                # [optional] devops home (defaults to '/opt/devops').
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

# set appdynamics platform installation variables. -----------------------------
appd_platform_folder="${appd_home}/${appd_platform_home}"
appd_platform_installer="platform-setup-x64-linux-${appd_platform_rel}.sh"

# install platform prerequisites. ----------------------------------------------
# install the netstat network utility.
yum -y install net-tools

# install the asynchronous i/o library.
yum -y install libaio

# install the simple non-uniform memory access (numa) policy support package.
yum -y install numactl

# configure file and process limits for user 'root'.
ulimit -S -n
ulimit -S -u

user_limits_dir="/etc/security/limits.d"
appd_conf="appdynamics.conf"
num_file_descriptors="65535"
num_processes="8192"

if [ -d "$user_limits_dir" ]; then
  rm -f "${user_limits_dir}/${appd_conf}"

  echo "root hard nofile ${num_file_descriptors}" > "${user_limits_dir}/${appd_conf}"
  echo "root soft nofile ${num_file_descriptors}" >> "${user_limits_dir}/${appd_conf}"
  echo "root hard nproc ${num_processes}" >> "${user_limits_dir}/${appd_conf}"
  echo "root soft nproc ${num_processes}" >> "${user_limits_dir}/${appd_conf}"
fi

# add user limits to the pluggable authentication modules (pam).
pam_dir="/etc/pam.d"
session_conf="common-session"
session_cmd="session required pam_limits.so"
if [ -d "$pam_dir" ]; then
  if [ -f "$session_conf" ]; then
    grep -qF "${session_cmd}" ${session_conf} || echo "${session_cmd}" >> ${session_conf}
  else
    echo "${session_cmd}" > ${session_conf}
  fi
fi

# verify new file and process limits.
runuser -c "ulimit -S -n" -
runuser -c "ulimit -S -u" -

# create temporary download directory. -----------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/centos/appdynamics
cd ${devops_home}/provisioners/scripts/centos/appdynamics

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# download the appdynamics platform installer. ---------------------------------
# authenticate to the appdynamics domain and store session id in a file.
curl --silent --cookie-jar cookies-${curdate}.txt --data "username=${appd_username}&password=${appd_password}" https://login.appdynamics.com/sso/login/

# download the installer.
rm -f ${appd_platform_installer}
curl --silent --location --remote-name --cookie cookies-${curdate}.txt https://download.appdynamics.com/download/prox/download-file/enterprise-console/${appd_platform_rel}/${appd_platform_installer}
chmod 755 ${appd_platform_installer}

rm -f cookies-${curdate}.txt

# create silent response file for installer. -----------------------------------
response_file="appd-platform-response.varfile"

rm -f "${response_file}"

echo "serverHostName=${appd_server_host}" >> "${response_file}"
echo "sys.languageId=en" >> "${response_file}"
echo "disableEULA=true" >> "${response_file}"
echo "platformAdmin.port=${appd_server_port}" >> "${response_file}"
echo "platformAdmin.databasePort=3377" >> "${response_file}"
echo "platformAdmin.dataDir=${appd_platform_folder}/mysql/data" >> "${response_file}"
echo "platformAdmin.databasePassword=${appd_db_password}" >> "${response_file}"
echo "platformAdmin.databaseRootPassword=${appd_db_root_password}" >> "${response_file}"
echo "platformAdmin.adminUsername=${appd_admin_username}" >> "${response_file}"
echo "platformAdmin.adminPassword=${appd_admin_password}" >> "${response_file}"
echo "platformAdmin.platformDir=${appd_platform_folder}" >> "${response_file}"

# install the appdynamics enterprise console. ----------------------------------
# run the silent installer for linux.
./${appd_platform_installer} -q -varfile ${response_file}

# verify installation.
cd ${appd_platform_folder}/platform-admin/bin
./platform-admin.sh show-platform-admin-version

# shutdown the appdynamics platform components. --------------------------------
# stop the appdynamics enterprise console.
./platform-admin.sh stop-platform-admin

# configure the appdynamics enterprise console as a service. -------------------
systemd_dir="/etc/systemd/system"
appd_enterprise_console_service="appd-enterprise-console.service"
service_filepath="${systemd_dir}/${appd_enterprise_console_service}"

# create systemd service file.
if [ -d "$systemd_dir" ]; then
  rm -f "${service_filepath}"

  touch "${service_filepath}"
  chmod 644 "${service_filepath}"

  echo "[Unit]" >> "${service_filepath}"
  echo "Description=The AppDynamics Enterprise Console." >> "${service_filepath}"
  echo "After=network.target remote-fs.target nss-lookup.target" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "[Service]" >> "${service_filepath}"
  echo "Type=forking" >> "${service_filepath}"
  echo "ExecStart=/opt/appdynamics/platform/platform-admin/bin/platform-admin.sh start-platform-admin" >> "${service_filepath}"
  echo "ExecStop=/opt/appdynamics/platform/platform-admin/bin/platform-admin.sh stop-platform-admin" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "[Install]" >> "${service_filepath}"
  echo "WantedBy=multi-user.target" >> "${service_filepath}"
fi

# reload systemd manager configuration.
systemctl daemon-reload

# enable the enterprise console to start at boot time.
systemctl enable "${appd_enterprise_console_service}"
systemctl is-enabled "${appd_enterprise_console_service}"

# check current status.
#systemctl status "${appd_enterprise_console_service}"
