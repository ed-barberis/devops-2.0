#!/bin/sh -eux
# install cloud-init cloud initialization tool on centos 7.x.

# update the repository list. --------------------------------------------------
yum repolist

# reinstall the python 'urllib3' library. --------------------------------------
pip uninstall -y urllib3
yum -y install python-urllib3
pip install -U urllib3

# install cloud-init. ----------------------------------------------------------
yum -y install cloud-init

# verify installation.
cloud-init --version
