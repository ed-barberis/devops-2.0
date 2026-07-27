#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install Splunk Enterprise 10.2.x by Cisco on Ubuntu Linux.
#
# Splunk Enterprise is a software product that enables you to search, analyze, and visualize the
# data gathered from the components of your IT infrastructure or business. Splunk Enterprise takes
# in data from websites, applications, sensors, devices, and so on. After you define the data
# source, Splunk Enterprise indexes the data stream and parses it into a series of individual events
# that you can view and search.
#
# For more details, please visit:
#   https://help.splunk.com/en/splunk-enterprise/get-started/overview/10.2/about-splunk-enterprise/about-splunk-enterprise
#   https://help.splunk.com/en/splunk-enterprise/get-started/install-and-upgrade/10.2/welcome-to-the-splunk-enterprise-installation-manual/whats-in-this-manual
#   https://help.splunk.com/en/splunk-enterprise/administer/manage-users-and-security/10.2/install-splunk-enterprise-securely/create-secure-administrator-credentials
#   https://www.splunk.com/en_us/download/splunk-enterprise.html
#
# NOTE: All inputs are defined by external environment variables.
#       Optional variables have reasonable defaults, but you may override as needed.
#       Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] splunk enterprise install parameters [w/ defaults].
# splunk enterprise install parameters.
SPLUNK_HOME="${SPLUNK_HOME:-/opt/splunk}"
splunk_enterprise_release="${splunk_enterprise_release:-10.4.1}"
splunk_enterprise_hash="${splunk_enterprise_hash:-5a009d941268}"
splunk_enterprise_sha512="${splunk_enterprise_sha512:-ee641bc370ff8a476fc9ffeba75bced9ae87aabce8d07d7ca4a6e4e3101835042550bf2b8c530c17e25ae66badf40a1be862e09007f0a7cb0a23e26f9eac3c80}"
splunk_enterprise_user_name="${splunk_enterprise_user_name:-splunk}"
splunk_enterprise_user_group="${splunk_enterprise_user_group:-splunk}"

set +x  # temporarily turn command display OFF.
splunk_enterprise_admin_username="${splunk_enterprise_admin_username:-admin}"
splunk_enterprise_admin_password="${splunk_enterprise_admin_password:-Welcome1}"
set -x  # turn command display back ON.

# [OPTIONAL] devops home folder [w/ default].
devops_home="${devops_home:-/opt/devops}"

# validate ubuntu release version. -----------------------------------------------------------------
# check for supported ubuntu release.
ubuntu_release=$(lsb_release -rs)

if [ -n "$ubuntu_release" ]; then
  case $ubuntu_release in
      22.04|24.04)
        ;;

      *)
        echo "Error: Splunk Enterprise 10.2.x NOT supported on Ubuntu release: '$(lsb_release -ds)'."
        exit 1
        ;;
  esac
fi

# update the apt repository package indexes. -------------------------------------------------------
apt-get update

# create scripts directory (if needed). ------------------------------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/ubuntu
cd ${devops_home}/provisioners/scripts/ubuntu

# download splunk enterprise. ----------------------------------------------------------------------
splunk_enterprise_binary="splunk-${splunk_enterprise_release}-${splunk_enterprise_hash}-linux-amd64.deb"

# download the splunk enterprise package.
rm -f ${splunk_enterprise_binary}
wget --no-verbose -O ${splunk_enterprise_binary} "https://download.splunk.com/products/splunk/releases/${splunk_enterprise_release}/linux/${splunk_enterprise_binary}"

# verify the downloaded binary.
echo "${splunk_enterprise_sha512} ${splunk_enterprise_binary}" | sha512sum --check
# splunk-${splunk_enterprise_release}-${splunk_enterprise_hash}-linux-amd64.deb: OK

# install splunk enterprise. -----------------------------------------------------------------------
# install splunk enterprise package.
export DEBIAN_FRONTEND=noninteractive
dpkg -i ${splunk_enterprise_binary}

# generate a hashed password for the splunk enterprise admin user.
cd ${SPLUNK_HOME}/bin
set +x  # temporarily turn command display OFF.
splunk_enterprise_admin_hash_password=$(./splunk hash-passwd ${splunk_enterprise_admin_password})
set -x  # turn command display back ON.

# generate the splunk enterprise 'user-seed.conf' file to allow configuration of splunk's initial
# username and password.
rm -f ${SPLUNK_HOME}/etc/system/local/user-seed.conf

cat <<EOF >  ${SPLUNK_HOME}/etc/system/local/user-seed.conf
# Version ${splunk_enterprise_release}
#
# This 'user-seed.conf' is used to create an initial login.
#
# NOTE: When starting Splunk for first time, the hashed password is stored in
# '$SPLUNK_HOME/etc/system/local/user-seed.conf' and the password file is seeded with this hash.
# This file can also be used to set the default username and password, if '$SPLUNK_HOME/etc/passwd'
# is not present. If the '$SPLUNK_HOME/etc/passwd' file is present, the settings in this file
# ('user-seed.conf') are not used.
#
# To use this configuration, copy the configuration block into 'user-seed.conf' in
# '$SPLUNK_HOME/etc/system/local/'. You must restart Splunk to enable configurations.
#
# To learn more about configuration files (including precedence) please see the documentation:
# https://help.splunk.com/en/splunk-enterprise/administer/admin-manual/10.2/administer-splunk-enterprise-with-configuration-files/about-configuration-files

[user_info]
USERNAME = ${splunk_enterprise_admin_username}
HASHED_PASSWORD = ${splunk_enterprise_admin_hash_password}
EOF

# update ownership properties for the splunk enterprise installation. ------------------------------
cd ${SPLUNK_HOME}
chown -R ${splunk_enterprise_user_name}:${splunk_enterprise_user_group} .

# enable auto-start on vm boot and start splunk enterprise. ----------------------------------------
runuser -c "sudo ${SPLUNK_HOME}/bin/splunk enable boot-start -systemd-managed 1 -user ${splunk_enterprise_user_name} -group ${splunk_enterprise_user_group} --accept-license" - ${splunk_enterprise_user_name}
echo "Pausing 10 seconds to allow server configuration to complete..."
sleep 10

# validate that the splunk service is boot enabled.
systemctl is-enabled Splunkd.service

# start splunk enterprise.
runuser -c "sudo ${SPLUNK_HOME}/bin/splunk start" - ${splunk_enterprise_user_name}
echo "Pausing 60 seconds to allow server startup to complete..."
sleep 60

# verify splunk enterprise installation. -----------------------------------------------------------
set +x  # temporarily turn command display OFF.
runuser -c "${SPLUNK_HOME}/bin/splunk login -auth ${splunk_enterprise_admin_username}:${splunk_enterprise_admin_password}" - ${splunk_enterprise_user_name}
set -x  # turn command display back ON.

runuser -c "${SPLUNK_HOME}/bin/splunk status" - ${splunk_enterprise_user_name}
runuser -c "${SPLUNK_HOME}/bin/splunk show web-port" - ${splunk_enterprise_user_name}
runuser -c "${SPLUNK_HOME}/bin/splunk version" - ${splunk_enterprise_user_name}

# shutdown splunk enterprise. ----------------------------------------------------------------------
runuser -c "sudo ${SPLUNK_HOME}/bin/splunk stop" - ${splunk_enterprise_user_name}

# update ownership properties for the splunk enterprise installation one final time. ---------------
cd ${SPLUNK_HOME}
chown -R ${splunk_enterprise_user_name}:${splunk_enterprise_user_group} .
