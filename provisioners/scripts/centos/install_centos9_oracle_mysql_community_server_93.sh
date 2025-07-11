#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install MySQL Community Server 9.3 by Oracle on CentOS Linux 9.x.
#
# The MySQL software delivers a very fast, multithreaded, multi-user, and robust SQL (Structured
# Query Language) database server. MySQL Server is intended for mission-critical, heavy-load
# production systems as well as for embedding into mass-deployed software.
#
# For more details, please visit:
#   https://dev.mysql.com/doc/refman/9.3/en/
#   https://dev.mysql.com/doc/refman/9.3/en/linux-installation-yum-repo.html
#   https://dev.mysql.com/downloads/repo/yum/
#   https://www.mysql.com/support/supportedplatforms/database.html
#   https://dev.mysql.com/doc/refman/9.3/en/socket-pluggable-authentication.html
#
# NOTE: All inputs are defined by external environment variables.
#       Optional variables have reasonable defaults, but you may override as needed.
#       Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] mysql server install parameters [w/ defaults].
set +x  # temporarily turn command display OFF.
mysql_server_root_password="${mysql_server_root_password:-Welcome1!}"   # [optional] root password (defaults to 'Welcome1!').
set -x  # turn command display back ON.
mysql_yum_release="${mysql_yum_release:-84}"                            # [optional] yum repository version (defaults to '84').
mysql_server_default="${mysql_server_default:-mysql-8.4-lts-community}" # [optional] mysql server default version (defaults to 'mysql-8.4-lts-community').
                                                                        # [optional] mysql server release version (defaults to 'mysql-innovation-community').
mysql_server_release="${mysql_server_release:-mysql-innovation-community}"
                                                                        # [optional] mysql yum repository md5 checksum (defaults to published value).
mysql_yum_checksum="${mysql_yum_checksum:-15a20fea9018662224f354cb78b392e7}"
mysql_enable_secure_access="${mysql_enable_secure_access:-true}"        # [optional] enable secure access for mysql server (defaults to 'true').

# [OPTIONAL] devops home folder [w/ default].
devops_home="${devops_home:-/opt/devops}"                               # [optional] devops home (defaults to '/opt/devops').

# create scripts directory (if needed). ------------------------------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# download mysql yum repository. -------------------------------------------------------------------
mysql_yum_binary="mysql${mysql_yum_release}-community-release-el9-1.noarch.rpm"

# download the mysql yum repository.
rm -f ${mysql_yum_binary}
wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://dev.mysql.com/get/${mysql_yum_binary}

# verify the downloaded binary using the md5 checksum.
echo "${mysql_yum_checksum} ${mysql_yum_binary}" | md5sum --check -
# mysql${mysql_yum_release}-community-release-el9-1.noarch.rpm: OK

# install the mysql public gpg key.
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023

# verify the downloaded binary using the built-in gpg signature.
rpm --checksig ${mysql_yum_binary}

# install mysql server. ----------------------------------------------------------------------------
# install mysql yum repository.
dnf -y localinstall ${mysql_yum_binary}

# enable/disable mysql subrepositories.
dnf config-manager --disable ${mysql_server_default}
dnf config-manager --enable ${mysql_server_release}

# install mysql server binaries.
#dnf -y remove mariadb-libs                 # [optional] if running in the desktop.
dnf -y install mysql-community-server
#dnf -y install mysql-workbench-community   # [optional]

# verify mysql server installation
mysql --version
mysqladmin --version

# configure mysql server. --------------------------------------------------------------------------
# start the mysql service and configure it to start at boot time.
systemctl start mysqld
systemctl enable mysqld
systemctl is-enabled mysqld

# check that the mysql service is running.
systemctl status mysqld

# create mysql server 'root' user password. --------------------------------------------------------
# set the 'root' user password and change authentication method to 'caching_sha2_password'.
mysql_server_temp_password=$(awk '/temporary password/ {print $13}' /var/log/mysqld.log)
set +x  # temporarily turn command display OFF.
mysql_cmd="mysql -u root --password='${mysql_server_temp_password}' --connect-expired-password -e \"ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '${mysql_server_root_password}';\""
#echo "mysql_cmd: \"${mysql_cmd}\""
eval ${mysql_cmd}
set -x  # turn command display back ON.

# verify 'root' user authentication method.
set +x  # temporarily turn command display OFF.
mysql -u root -p${mysql_server_root_password} -e "SELECT user, plugin FROM mysql.user WHERE user IN ('root')\G;"
set -x    # turn command display back ON.

# improve mysql server installation security. ------------------------------------------------------
# if secure access is enabled, remove anonymous users, disallow remote 'root' logins, and remove test database.
if [ "$mysql_enable_secure_access" = "true" ]; then
  # run the mysql secure install command with the following pre-set answers using the 'here string' (<<<) defined below:
  #   The 'validate_password' component is installed on the server.
  #   Change the password for root ? ((Press y|Y for Yes, any other key for No) : N
  #   Remove anonymous users? (Press y|Y for Yes, any other key for No) : Y
  #   Disallow root login remotely? (Press y|Y for Yes, any other key for No) : Y
  #   Remove test database and access to it? (Press y|Y for Yes, any other key for No) : Y
  #   Reload privilege tables now? (Press y|Y for Yes, any other key for No) : Y
  set +x  # temporarily turn command display OFF.
  mysql_secure_install_cmd=$(printf "mysql_secure_installation -u root -p%s <<< \$\'%s\\\\n%s\\\\n%s\\\\n%s\\\\n%s\\\\n\'\n" ${mysql_server_root_password} N Y Y Y Y)
  #echo "mysql_secure_install_cmd: \"${mysql_secure_install_cmd}\""
  eval ${mysql_secure_install_cmd}
  set -x    # turn command display back ON.
else
  # run the mysql secure install command with the following pre-set answers using the 'here string' (<<<) defined below:
  #   The 'validate_password' component is installed on the server.
  #   Change the password for root ? ((Press y|Y for Yes, any other key for No) : N
  #   Remove anonymous users? (Press y|Y for Yes, any other key for No) : N
  #   Disallow root login remotely? (Press y|Y for Yes, any other key for No) : N
  #   Remove test database and access to it? (Press y|Y for Yes, any other key for No) : N
  #   Reload privilege tables now? (Press y|Y for Yes, any other key for No) : Y
  set +x  # temporarily turn command display OFF.
  mysql_secure_install_cmd=$(printf "mysql_secure_installation -u root -p%s <<< \$\'%s\\\\n%s\\\\n%s\\\\n%s\\\\n%s\\\\n\'\n" ${mysql_server_root_password} N N N N Y)
  #echo "mysql_secure_install_cmd: \"${mysql_secure_install_cmd}\""
  eval ${mysql_secure_install_cmd}
  set -x    # turn command display back ON.
fi

# display configuration info and verify version. ---------------------------------------------------
set +x  # temporarily turn command display OFF.
mysqladmin -u root -p${mysql_server_root_password} version
set -x  # turn command display back ON.

# if secure access is enabled, install the 'auth_socket' plugin via the mysql config file. ---------
if [ "$mysql_enable_secure_access" = "true" ]; then
  # stop the mysql service to edit the mysql config file.
  systemctl stop mysqld

  # add the following options under the '[mysqld]' option group.
  mysql_config_filepath="/etc/my.cnf"
  if [ -f "$mysql_config_filepath" ]; then
    echo "" >> "${mysql_config_filepath}"
    echo "plugin-load-add=auth_socket.so" >> "${mysql_config_filepath}"
    echo "auth_socket=FORCE_PLUS_PERMANENT" >> "${mysql_config_filepath}"
  fi

  # start the mysql service.
  systemctl start mysqld

  # for secure access, change the 'root' user authentication method back to 'auth_socket'.
  set +x  # temporarily turn command display OFF.
  mysql -u root -p${mysql_server_root_password} -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;"
  mysql -u root -p${mysql_server_root_password} -e "SELECT user, plugin FROM mysql.user WHERE user IN ('root')\G;"
  set -x    # turn command display back ON.
fi

# display installed plugins.
set +x  # temporarily turn command display OFF.
mysql -u root -p${mysql_server_root_password} -e "SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_STATUS LIKE '%ACTIVE%'\G;"
set -x    # turn command display back ON.
