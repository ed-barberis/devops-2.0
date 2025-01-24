#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install MySQL Shell 9.2 by Oracle on CentOS Linux 8.x.
#
# MySQL Shell is an advanced client and code editor for MySQL. In addition to the provided SQL
# functionality, similar to 'mysql', MySQL Shell provides scripting capabilities for JavaScript
# and Python and includes APIs for working with MySQL.
#
# MySQL Shell 9.2 is highly recommended for use with MySQL Server 9.2.
#
# For more details, please visit:
#   https://dev.mysql.com/doc/mysql-shell/9.2/en/
#   https://dev.mysql.com/doc/mysql-shell/9.2/en/mysql-shell-install-linux-quick.html
#   https://dev.mysql.com/downloads/shell
#   https://dev.mysql.com/doc/relnotes/mysql-shell/9.2/en/
#
# NOTE: All inputs are defined by external environment variables.
#       Optional variables have reasonable defaults, but you may override as needed.
#       Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] mysql shell install parameters [w/ defaults].
mysqlsh_release="${mysqlsh_release:-9.2.0-1}"                               # [optional] mysql release version (defaults to '9.2.0-1').

# [OPTIONAL] devops home folder [w/ default].
devops_home="${devops_home:-/opt/devops}"                                   # [optional] devops home (defaults to '/opt/devops').

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# set the mysql shell md5 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  mysqlsh_checksum="${mysqlsh_checksum:-e4692b4f4a3a092553c0d6d71df65208}"  # [optional] mysql shell repository amd64 md5 checksum (defaults to published value).
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  mysqlsh_checksum="${mysqlsh_checksum:-ce5cd256e64eb5897b318ffa98d9c64c}"  # [optional] mysql shell repository arm64 md5 checksum (defaults to published value).
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create scripts directory (if needed). ------------------------------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# install mysql shell. -----------------------------------------------------------------------------
mysqlsh_binary="mysql-shell-${mysqlsh_release}.el8.${cpu_arch}.rpm"

# download mysql shell repository.
rm -f ${mysqlsh_binary}
wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://dev.mysql.com/get/Downloads/MySQL-Shell/${mysqlsh_binary}

# verify the downloaded binary using the md5 checksum.
echo "${mysqlsh_checksum} ${mysqlsh_binary}" | md5sum --check -
# mysql-shell-${mysqlsh_release}.el8.x86_64.rpm: OK
# mysql-shell-${mysqlsh_release}.el8.aarch64.rpm: OK

# install mysql shell. -----------------------------------------------------------------------------
dnf -y install ${mysqlsh_binary}

# verify mysql shell installation.
mysqlsh --version

# mysqlsh command-line examples. -------------------------------------------------------------------
# MySQL Shell User Guide
#   This is the MySQL Shell User Guide extract from the MySQL 9.2 Reference Manual.
#   https://dev.mysql.com/doc/mysql-shell-excerpt/9.2/en/
#
#   For help with using MySQL, please visit either the MySQL Forums or MySQL Mailing Lists,
#   where you can discuss your issues with other MySQL users.
#
# Example Usage:
#   $ mysqlsh
#   MySQL JS > \connect root@localhost:3306
#   MySQL JS > \sql
#   MySQL JS > show databases;
#   MySQL JS > \use mysql
#   MySQL JS > show tables;
#   MySQL JS > \exit
