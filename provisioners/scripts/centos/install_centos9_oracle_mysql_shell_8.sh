#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install MySQL Shell 8.0 by Oracle on CentOS Linux 9.x.
#
# MySQL Shell is an advanced client and code editor for MySQL. In addition to the provided SQL
# functionality, similar to 'mysql', MySQL Shell provides scripting capabilities for JavaScript
# and Python and includes APIs for working with MySQL.
#
# MySQL Shell 8.0 is highly recommended for use with both MySQL Server 8.0 and 5.7.
#
# For more details, please visit:
#   https://dev.mysql.com/doc/mysql-shell/8.0/en/
#   https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-install-linux-quick.html
#   https://dev.mysql.com/downloads/shell
#   https://dev.mysql.com/doc/relnotes/mysql-shell/8.0/en/
#
# NOTE: All inputs are defined by external environment variables.
#       Optional variables have reasonable defaults, but you may override as needed.
#       Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] mysql shell install parameters [w/ defaults].
mysqlsh_release="${mysqlsh_release:-8.0.42-1}"                              # [optional] mysql release version (defaults to '8.0.42-1').

# [OPTIONAL] devops home folder [w/ default].
devops_home="${devops_home:-/opt/devops}"                                   # [optional] devops home (defaults to '/opt/devops').

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# set the mysql shell md5 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  mysqlsh_checksum="${mysqlsh_checksum:-70885f84935e7131d889c14356cc9805}"  # [optional] mysql shell repository amd64 md5 checksum (defaults to published value).
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  mysqlsh_checksum="${mysqlsh_checksum:-8a4e4ea8fcffa00c0c912929d0045781}"  # [optional] mysql shell repository arm64 md5 checksum (defaults to published value).
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create scripts directory (if needed). ------------------------------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# install mysql shell. -----------------------------------------------------------------------------
mysqlsh_binary="mysql-shell-${mysqlsh_release}.el9.${cpu_arch}.rpm"

# download mysql shell repository.
rm -f ${mysqlsh_binary}
wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://dev.mysql.com/get/Downloads/MySQL-Shell/${mysqlsh_binary}

# verify the downloaded binary using the md5 checksum.
echo "${mysqlsh_checksum} ${mysqlsh_binary}" | md5sum --check -
# mysql-shell-${mysqlsh_release}.el9.x86_64.rpm: OK
# mysql-shell-${mysqlsh_release}.el9.aarch64.rpm: OK

# install mysql shell. -----------------------------------------------------------------------------
dnf -y install ${mysqlsh_binary}

# verify mysql shell installation.
mysqlsh --version

# mysqlsh command-line examples. -------------------------------------------------------------------
# MySQL Shell User Guide
#   This is the MySQL Shell User Guide extract from the MySQL 8.0 Reference Manual.
#   https://dev.mysql.com/doc/mysql-shell-excerpt/8.0/en/
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
