#!/bin/sh -eux
# install python 3.3 from the software collection library for linux 7.x..

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# create scripts directory (if needed). ----------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# install python 3.3. ----------------------------------------------------------
yum -y install python33
scl enable python33 -- python --version

# install python 3.3 pip. ------------------------------------------------------
wget --no-verbose https://bootstrap.pypa.io/get-pip.py
scl enable python33 -- python ${devops_home}/provisioners/scripts/centos/get-pip.py
scl enable python33 -- pip --version
scl enable python33 -- pip3 --version
