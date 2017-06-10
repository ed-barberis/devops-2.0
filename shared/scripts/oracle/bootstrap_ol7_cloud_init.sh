#!/bin/sh -eux
# install cloud-init cloud initialization tool on oracle linux 7.x.

# enable the oracle linux 7 optional packages. ---------------------------------
yum-config-manager --enable ol7_optional_latest

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
