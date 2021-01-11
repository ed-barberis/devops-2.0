#!/bin/sh -eux
# install the oracle linux 8 uekr6 kernel.

# ensure that the uekr6 kernel is enabled by default. ----------------------------------------------
yum-config-manager --enable ol8_UEKR6
yum-config-manager --enable ol8_addons

yum -y install oracle-epel-release-el8
yum -y install oraclelinux-developer-release-el8

yum-config-manager --enable ol8_developer_EPEL
yum-config-manager --enable ol8_developer

# install the latest ol8 updates. ------------------------------------------------------------------
yum -y update

# install kernel development tools and headers for building guest additions. -----------------------
yum -y install kernel-uek-devel
yum -y install kernel-uek
