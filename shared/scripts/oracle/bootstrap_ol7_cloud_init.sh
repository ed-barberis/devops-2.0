#!/bin/sh -eux
# install cloud-init cloud initialization tool on oracle linux 7.x.

# enable the oracle linux 7 optional packages. ---------------------------------
yum-config-manager --enable ol7_optional_latest

# update the repository list. --------------------------------------------------
yum repolist

# install cloud-init. ----------------------------------------------------------
yum -y install cloud-init

# verify installation.
cloud-init --version
