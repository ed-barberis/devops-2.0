#!/bin/sh -eux
# install appdynamics events service and controller platform services by appdynamics.

# set default values for input environment variables if not set. ---------------
# appd platform install parameters.
appd_home="${appd_home:-/opt/appdynamics}"                                      # [optional] appd home (defaults to '/opt/appdynamics').
appd_admin_username="${appd_admin_username:-admin}"                             # [optional] appd admin user name (defaults to user 'admin').
appd_admin_password="${appd_admin_password:-welcome1}"                          # [optional] appd admin password (defaults to 'welcome1').
appd_platform_home="${appd_platform_home:-platform}"                            # [optional] appd platform home (defaults to 'platform').
appd_platform_name="${appd_platform_name:-My Platform}"                         # [optional] appd platform name (defaults to 'My Platform').
appd_platform_description="${appd_platform_description:-My platform config.}"   # [optional] appd platform description (defaults to 'My platform config.').
appd_platform_install_dir="${appd_platform_install_dir:-product}"               # [optional] appd platform base installation directory for platform products (defaults to 'product').
appd_platform_hosts="${appd_platform_hosts:-platformadmin}"                     # [optional] appd platform hosts (defaults to 'platformadmin' which is the localhost).

# appd events service install parameters.
appd_events_service_hosts="${appd_events_service_hosts:-platformadmin}"         # [optional] appd events service hosts (defaults to 'platformadmin' which is the localhost).
appd_events_service_profile="${appd_events_service_profile:-DEV}"               # [optional] appd events service profile (defaults to 'DEV').
                                                                                #            valid profiles are:
                                                                                #              'DEV', 'dev', 'PROD', 'prod'
# appd controller install parameters.
appd_controller_primary_host="${appd_controller_primary_host:-platformadmin}"   # [optional] appd controller primary host (defaults to 'platformadmin' which is the localhost).
appd_controller_admin_username="${appd_controller_admin_username:-admin}"       # [optional] appd controller admin user name (defaults to 'admin').
appd_controller_admin_password="${appd_controller_admin_password:-welcome1}"    # [optional] appd controller admin password (defaults to 'welcome1').
appd_controller_root_password="${appd_controller_root_password:-welcome1}"      # [optional] appd controller root password (defaults to 'welcome1').
appd_controller_mysql_password="${appd_controller_mysql_password:-welcome1}"    # [optional] appd controller mysql root password (defaults to 'welcome1').

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                                       # [optional] devops home (defaults to '/opt/devops').

# define usage function. -------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
   # appd platform install parameters.
    [root]# export appd_home="/opt/appdynamics"                     # [optional] appd home (defaults to '/opt/appdynamics').
    [root]# export appd_admin_username="admin"                      # [optional] appd admin user name (defaults to user 'admin').
    [root]# export appd_admin_password="welcome1"                   # [optional] appd admin password (defaults to 'welcome1').
    [root]# export appd_platform_home="platform"                    # [optional] appd platform home (defaults to 'platform').
    [root]# export appd_platform_name="My Platform"                 # [optional] appd platform name (defaults to 'My Platform').
    [root]# export appd_platform_description="My platform config."  # [optional] appd platform description (defaults to 'My platform config.').
    [root]# export appd_platform_install_dir="product"              # [optional] appd platform base installation directory for platform products (defaults to 'product').
    [root]# export appd_platform_hosts="platformadmin"              # [optional] appd platform hosts (defaults to 'platformadmin' which is the localhost).
   #
   # appd events service install parameters.
    [root]# export appd_events_service_hosts="platformadmin"        # [optional] appd events service hosts (defaults to 'platformadmin' which is the localhost).
    [root]# export appd_events_service_profile="DEV"                # [optional] appd events service profile (defaults to 'DEV').
                                                                    #            valid profiles are:
                                                                    #              'DEV', 'dev', 'PROD', 'prod'
   # appd controller install parameters.
    [root]# export appd_controller_primary_host="platformadmin"     # [optional] appd controller primary host (defaults to 'platformadmin' which is the localhost).
    [root]# export appd_controller_admin_username="admin"           # [optional] appd controller admin user name (defaults to 'admin').
    [root]# export appd_controller_admin_password="welcome1"        # [optional] appd controller admin password (defaults to 'welcome1').
    [root]# export appd_controller_root_password="welcome1"         # [optional] appd controller root password (defaults to 'welcome1').
    [root]# export appd_controller_mysql_password="welcome1"        # [optional] appd controller mysql root password (defaults to 'welcome1').
   #
   # devops home parameter.
    [root]# export devops_home="/opt/devops"                        # [optional] devops home (defaults to '/opt/devops').
    [root]# $0
EOF
}

# validate environment variables. ----------------------------------------------
if [ -n "$appd_events_service_profile" ]; then
  case $appd_events_service_profile in
      DEV|dev|PROD|prod)
        ;;
      *)
        echo "Error: invalid 'appd_events_service_profile'."
        usage
        exit 1
        ;;
  esac
fi

# set appdynamics platform installation variables. -----------------------------
appd_platform_folder="${appd_home}/${appd_platform_home}"
appd_product_folder="${appd_home}/${appd_platform_home}/${appd_platform_install_dir}"

# start the appdynamics enterprise console. ------------------------------------
cd ${appd_platform_folder}/platform-admin/bin
./platform-admin.sh start-platform-admin

# verify installation.
cd ${appd_platform_folder}/platform-admin/bin
./platform-admin.sh show-platform-admin-version

# login to the appdynamics platform. -------------------------------------------
./platform-admin.sh login --user-name "${appd_admin_username}" --password "${appd_admin_password}"

# create an appdynamics platform. ----------------------------------------------
./platform-admin.sh create-platform --name "${appd_platform_name}" --description "${appd_platform_description}" --installation-dir "${appd_product_folder}"

# add local host ('platformadmin') to platform. --------------------------------
./platform-admin.sh add-hosts --hosts "${appd_platform_hosts}"

# install appdynamics events service. ------------------------------------------
./platform-admin.sh install-events-service --profile "${appd_events_service_profile}" --hosts "${appd_events_service_hosts}"

# verify installation.
./platform-admin.sh show-events-service-health

# configure the appdynamics events service as a service. -----------------------
systemd_dir="/etc/systemd/system"
appd_events_service_service="appd-events-service.service"
service_filepath="${systemd_dir}/${appd_events_service_service}"

# create systemd service file.
if [ -d "$systemd_dir" ]; then
  rm -f "${service_filepath}"

  touch "${service_filepath}"
  chmod 644 "${service_filepath}"

  echo "[Unit]" >> "${service_filepath}"
  echo "Description=The AppDynamics Events Service." >> "${service_filepath}"
  echo "After=network.target remote-fs.target nss-lookup.target appd-enterprise-console.service" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "[Service]" >> "${service_filepath}"
  echo "Type=forking" >> "${service_filepath}"
  echo "RemainAfterExit=true" >> "${service_filepath}"
  echo "TimeoutStartSec=300" >> "${service_filepath}"
  echo "ExecStartPre=/opt/appdynamics/platform/platform-admin/bin/platform-admin.sh login --user-name ${appd_admin_username} --password ${appd_admin_password}" >> "${service_filepath}"
  echo "ExecStart=/opt/appdynamics/platform/platform-admin/bin/platform-admin.sh start-events-service" >> "${service_filepath}"
  echo "ExecStop=/opt/appdynamics/platform/platform-admin/bin/platform-admin.sh stop-events-service" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "[Install]" >> "${service_filepath}"
  echo "WantedBy=multi-user.target" >> "${service_filepath}"
fi

# reload systemd manager configuration.
systemctl daemon-reload

# enable the events service service to start at boot time.
systemctl enable "${appd_events_service_service}"
systemctl is-enabled "${appd_events_service_service}"

# check current status.
#systemctl status "${appd_events_service_service}"

# install appdynamics controller. ----------------------------------------------
./platform-admin.sh submit-job --service controller --job install --args controllerPrimaryHost="${appd_controller_primary_host}" controllerAdminUsername="${appd_controller_admin_username}" controllerAdminPassword="${appd_controller_admin_password}" controllerRootUserPassword="${appd_controller_root_password}" mysqlRootPassword="${appd_controller_mysql_password}"

# install license file.
cp ${devops_home}/provisioners/scripts/centos/tools/appd-controller-license.lic ${appd_platform_folder}/product/controller/license.lic

# verify installation.
curl --silent http://localhost:8090/controller/rest/serverstatus

# configure the appdynamics controller as a service. ---------------------------
systemd_dir="/etc/systemd/system"
appd_controller_service="appd-controller.service"
service_filepath="${systemd_dir}/${appd_controller_service}"

# create systemd service file.
if [ -d "$systemd_dir" ]; then
  rm -f "${service_filepath}"

  touch "${service_filepath}"
  chmod 644 "${service_filepath}"

  echo "[Unit]" >> "${service_filepath}"
  echo "Description=The AppDynamics Controller." >> "${service_filepath}"
  echo "After=network.target remote-fs.target nss-lookup.target appd-enterprise-console.service appd-events-service.service" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "[Service]" >> "${service_filepath}"
  echo "Type=forking" >> "${service_filepath}"
  echo "RemainAfterExit=true" >> "${service_filepath}"
  echo "TimeoutStartSec=600" >> "${service_filepath}"
  echo "TimeoutStopSec=120" >> "${service_filepath}"
  echo "ExecStartPre=/opt/appdynamics/platform/platform-admin/bin/platform-admin.sh login --user-name ${appd_admin_username} --password ${appd_admin_password}" >> "${service_filepath}"
  echo "ExecStart=/opt/appdynamics/platform/platform-admin/bin/platform-admin.sh start-controller-appserver --with-db" >> "${service_filepath}"
  echo "ExecStop=/opt/appdynamics/platform/platform-admin/bin/platform-admin.sh stop-controller-appserver --with-db" >> "${service_filepath}"
  echo "" >> "${service_filepath}"
  echo "[Install]" >> "${service_filepath}"
  echo "WantedBy=multi-user.target" >> "${service_filepath}"
fi

# reload systemd manager configuration.
systemctl daemon-reload

# enable the controller service to start at boot time.
systemctl enable "${appd_controller_service}"
systemctl is-enabled "${appd_controller_service}"

# check current status.
#systemctl status "${appd_controller_service}"

# verify overall platform installation. ----------------------------------------
./platform-admin.sh list-supported-services
./platform-admin.sh show-service-status --service controller
./platform-admin.sh show-service-status --service events-service

# shutdown the appdynamics platform components. --------------------------------
# stop the appdynamics controller.
./platform-admin.sh stop-controller-appserver --with-db

# stop the appdynamics events service.
./platform-admin.sh stop-events-service

# stop the appdynamics enterprise console.
./platform-admin.sh stop-platform-admin
