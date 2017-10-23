#!/bin/sh -eux
# install the oracle linux 7 uekr4 kernel.

# set current date for temporary filename. -------------------------------------
#curdate=$(date +"%Y-%m-%d")

# get the latest public yum ol7 repository file. -------------------------------
#cd /etc/yum.repos.d
#repofile="public-yum-ol7.repo"

#if [ -f "$repofile" ]; then
#  mv -f $repofile ${repofile}.${curdate}.orig
#fi

#wget --no-verbose http://yum.oracle.com/public-yum-ol7.repo

# ensure that the uekr4 kernel is enabled by default. --------------------------
#yum-config-manager --enable ol7_UEKR4
#yum-config-manager --disable ol7_UEKR3
#yum-config-manager --enable ol7_addons
#yum-config-manager --enable ol7_software_collections

# update the repository list. --------------------------------------------------
yum repolist

# install the latest ol7 updates. ----------------------------------------------
yum -y update

# install kernel development tools and headers for building guest additions. ---
#yum -y install kernel-uek-devel
#yum -y install kernel-uek

# remove package kit utility to turn-off auto-update of packages. --------------
yum -y remove PackageKit
