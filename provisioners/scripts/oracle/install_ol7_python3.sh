#!/bin/sh -eux
# install python 3.6 from the software collection library for linux 7.x..

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"   # [optional] devops home (defaults to '/opt/devops').

# create scripts directory (if needed). ------------------------------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/oracle
cd ${devops_home}/provisioners/scripts/oracle

# enable needed oracle linux 7 repositories. -------------------------------------------------------
yum-config-manager --enable ol7_optional_latest
yum-config-manager --enable ol7_software_collections

# install the software collections utility build tools. --------------------------------------------
yum -y install scl-utils-build

# install python 3.6. ------------------------------------------------------------------------------
yum -y install rh-python36

# verify installation.
scl enable rh-python36 -- python --version
scl enable rh-python36 -- python3 --version

# install python 3.6 pip. --------------------------------------------------------------------------
yum -y install rh-python36-python-pip
scl enable rh-python36 -- python -m pip install --upgrade pip

# verify installation.
scl enable rh-python36 -- pip --version
scl enable rh-python36 -- pip3 --version
