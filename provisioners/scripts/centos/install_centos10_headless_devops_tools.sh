#!/bin/sh -eux
# install useful headless (command-line) developer tools on centos 10.

# install epel repository. -------------------------------------------------------------------------
dnf config-manager --set-enabled crb
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
dnf repolist

# install git. -------------------------------------------------------------------------------------
dnf -y install git
git --version
