#!/bin/sh -eux
# install python 3.6 from the software collection library for linux 7.x..

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# create scripts directory (if needed). ----------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/oracle
cd ${devops_home}/provisioners/scripts/oracle

# enable the oracle linux 7 optional packages. ---------------------------------
yum-config-manager --enable ol7_optional_latest

# install the software collections utility build tools. ------------------------
yum -y install scl-utils-build

# install python 3.6. ----------------------------------------------------------
yum -y install rh-python36

# verify installation.
scl enable rh-python36 -- python --version

# install python 3.6 pip. ------------------------------------------------------
rm -f get-pip.py
wget --no-verbose https://bootstrap.pypa.io/get-pip.py
scl enable rh-python36 -- python ${devops_home}/provisioners/scripts/oracle/get-pip.py

# verify installation.
scl enable rh-python36 -- pip --version
scl enable rh-python36 -- pip3 --version
