#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install MariaDB Community Server 11.8 by MariaDB on CentOS Stream 9 Linux.
#
# MariaDB Server is one of the most popular open source relational databases. It’s made by the
# original developers of MySQL and guaranteed to stay open source. It is part of most cloud
# offerings and the default in most Linux distributions.
#
# It is built upon the values of performance, stability, and openness, and MariaDB Foundation
# ensures contributions will be accepted on technical merit. Recent new functionality includes
# advanced clustering with Galera Cluster 4, compatibility features with Oracle Database and
# Temporal Data Tables, allowing one to query the data as it stood at any point in the past.
#
# For more details, please visit:
#   https://mariadb.com/docs/features/mariadb-community-server/#mariadb-community-server
#   https://mariadb.com/downloads/
#   https://mariadb.org/
#   https://mariadb.com/kb/en/a-mariadb-primer/
#
# NOTE: All inputs are defined by external environment variables.
#       Optional variables have reasonable defaults, but you may override as needed.
#       Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] mariadb server install parameters [w/ defaults].
set +x  # temporarily turn command display OFF.
mariadb_server_root_password="${mariadb_server_root_password:-Password1234!}"   # [optional] root password (defaults to 'Password1234!').
set -x  # turn command display back ON.

# validate centos stream release version. ----------------------------------------------------------
# check for supported centos stream release.
centos_release=$(hostnamectl | awk '/^.*Operating System: / {print $0}' | sed 's/^.*Operating System: //g')
#centos_release=$(hostnamectl | awk '/^.*Operating System: / {printf "%s %s %s", $3, $4, $5}')

if [ -n "$centos_release" ]; then
  case $centos_release in
      "AlmaLinux 9.6 (Sage Margay)"|"AlmaLinux 10.0 (Purple Lion)"|"CentOS Stream 9"|"CentOS Stream 10 (Coughlan)"|"Rocky Linux 9.6 (Blue Onyx)"|"Rocky Linux 10.0 (Red Quartz)")
#     "AlmaLinux 9.6 (Sage"|"AlmaLinux 10.0 (Purple"|"CentOS Stream 9"|"CentOS Stream 10"|"Rocky Linux 9.6"|"Rocky Linux 10.0")
        ;;
      *)
        echo "Error: MongoDB NOT supported on CentOS release: '${centos_release}'."
        exit 1
        ;;
  esac
fi

# install the latest os updates. -------------------------------------------------------------------
dnf -y update

# get current date/time in utc format.
# example: 2025-04-17 20:57 UTC
utc_date_time=$(date -u +"%Y-%m-%d %H:%M UTC")

# generate the mariadb server repository file.
rm -f /etc/yum.repos.d/MariaDB.repo

cat <<EOF > /etc/yum.repos.d/MariaDB.repo
# MariaDB 11.8 CentOS repository list - created ${utc_date_time}
# https://mariadb.org/download/
[mariadb]
name = MariaDB
# rpm.mariadb.org is a dynamic mirror if your preferred mirror goes offline. See https://mariadb.org/mirrorbits/ for details.
# baseurl = https://rpm.mariadb.org/11.8/centos/\$releasever/\$basearch
baseurl = https://mirror.its.dal.ca/mariadb/yum/11.8/centos/\$releasever/\$basearch
# gpgkey = https://rpm.mariadb.org/RPM-GPG-KEY-MariaDB
gpgkey = https://mirror.its.dal.ca/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck = 1
EOF

# install mariadb server. --------------------------------------------------------------------------
# install mariadb server binaries.
dnf -y update
dnf -y install MariaDB-server MariaDB-client

# configure mariadb server. ------------------------------------------------------------------------
# start the mariadb service and configure it to start at boot time.
systemctl enable --now mariadb

# check that the mariadb service is running.
systemctl is-enabled mariadb
systemctl status mariadb

# secure the mariadb installation and set the root password. ---------------------------------------
# run the mariadb secure install command with the following pre-set answers:
#   Enter current password for root (enter for none):
#   Switch to unix_socket authentication [Y/n] n
#   Change the root password? [Y/n] Y
#   New password:
#   Re-enter new password:
#   Remove anonymous users? [Y/n] Y
#   Disallow root login remotely? [Y/n] Y
#   Remove test database and access to it? [Y/n] Y
#   Reload privilege tables now? [Y/n] Y
set +x    # temporarily turn command display OFF.
mariadb_secure_install_cmd=$(printf "mariadb-secure-installation <<< \$\'\\\\n%s\\\\n%s\\\\n%s\\\\n%s\\\\n%s\\\\n%s\\\\n%s\\\\n%s\\\\n\'\n" n Y ${mariadb_server_root_password} ${mariadb_server_root_password} Y Y Y Y)
eval ${mariadb_secure_install_cmd}
set -x    # turn command display back ON.

# display configuration info and verify version. ---------------------------------------------------
set +x  # temporarily turn command display OFF.
mariadb-admin -u root -p${mariadb_server_root_password} version
set -x  # turn command display back ON.
