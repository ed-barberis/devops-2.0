#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install MariaDB Community Server 11.4 by MariaDB on Ubuntu Linux.
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

# validate ubuntu release version. -----------------------------------------------------------------
# check for supported ubuntu release.
ubuntu_release=$(lsb_release -rs)

if [ -n "$ubuntu_release" ]; then
  case $ubuntu_release in
      20.04|22.04|24.04|25.04)
        ;;
      *)
        echo "Error: MongoDB NOT supported on Ubuntu release: '$(lsb_release -ds)'."
        exit 1
        ;;
  esac
fi

# update the apt repository package indexes. -------------------------------------------------------
apt-get update

# prepare the mariadb server package for installation. ---------------------------------------------
# import the mariadb server repository key onto our ubuntu system.
sudo apt-get install apt-transport-https curl
sudo mkdir -p /etc/apt/keyrings
sudo curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'

# get current date/time in utc format.
# example: 2025-04-17 20:57 UTC
utc_date_time=$(date -u +"%Y-%m-%d %H:%M UTC")

# generate the mariadb server sources file.
rm -f /etc/apt/sources.list.d/mariadb.sources

cat <<EOF > /etc/apt/sources.list.d/mariadb.sources
# MariaDB 11.4 repository list - created ${utc_date_time}
# https://mariadb.org/download/
X-Repolib-Name: MariaDB
Types: deb
# deb.mariadb.org is a dynamic mirror if your preferred mirror goes offline. See https://mariadb.org/mirrorbits/ for details.
# URIs: https://deb.mariadb.org/11.4/ubuntu
URIs: https://mirror.its.dal.ca/mariadb/repo/11.4/ubuntu
Suites: $(lsb_release -cs)
Components: main main/debug
Signed-By: /etc/apt/keyrings/mariadb-keyring.pgp
EOF

# install mariadb server. --------------------------------------------------------------------------
# install mariadb server binaries.
apt-get update
apt-get -y install mariadb-server

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
