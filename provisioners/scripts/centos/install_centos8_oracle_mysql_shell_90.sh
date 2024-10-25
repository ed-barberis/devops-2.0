#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install MySQL Shell 9.0 by Oracle on CentOS Linux 8.x.
#
# MySQL Shell is an advanced client and code editor for MySQL. In addition to the provided SQL
# functionality, similar to 'mysql', MySQL Shell provides scripting capabilities for JavaScript
# and Python and includes APIs for working with MySQL.
#
# MySQL Shell 9.0 is highly recommended for use with MySQL Server 9.0.
#
# For more details, please visit:
#   https://dev.mysql.com/doc/mysql-shell/9.0/en/
#   https://dev.mysql.com/doc/mysql-shell/9.0/en/mysql-shell-install-linux-quick.html
#   https://dev.mysql.com/downloads/shell
#   https://dev.mysql.com/doc/relnotes/mysql-shell/9.0/en/
#
# NOTE: All inputs are defined by external environment variables.
#       Optional variables have reasonable defaults, but you may override as needed.
#       Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] mysql shell install parameters [w/ defaults].
mysqlsh_release="${mysqlsh_release:-9.0.0-1}"                               # [optional] mysql release version (defaults to '9.0.0-1').
mysqlsh_checksum="${mysqlsh_checksum:-addd5224dfd1c07a259d18f6faa07e20}"    # [optional] mysql shell repository md5 checksum (defaults to published value).

# [OPTIONAL] devops home folder [w/ default].
devops_home="${devops_home:-/opt/devops}"                                   # [optional] devops home (defaults to '/opt/devops').

# create scripts directory (if needed). ------------------------------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# install mysql shell. -----------------------------------------------------------------------------
mysqlsh_binary="mysql-shell-${mysqlsh_release}.el8.x86_64.rpm"

# download mysql shell repository.
rm -f ${mysqlsh_binary}
wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://dev.mysql.com/get/Downloads/MySQL-Shell/${mysqlsh_binary}

# verify the downloaded binary using the md5 checksum.
echo "${mysqlsh_checksum} ${mysqlsh_binary}" | md5sum --check -
# mysql-shell-${mysqlsh_release}.el8.x86_64.rpm: OK

# install mysql shell. -----------------------------------------------------------------------------
dnf -y install ${mysqlsh_binary}

# verify mysql shell installation.
mysqlsh --version

# mysqlsh command-line examples. -------------------------------------------------------------------
# MySQL Shell User Guide
#   This is the MySQL Shell User Guide extract from the MySQL 9.0 Reference Manual.
#   https://dev.mysql.com/doc/mysql-shell-excerpt/9.0/en/
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
