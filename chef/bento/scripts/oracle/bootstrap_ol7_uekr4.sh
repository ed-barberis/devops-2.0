#!/bin/sh -eux
# install the oracle linux 7 uekr4 kernel.

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d")

# get the latest public yum ol7 repository file. -------------------------------
cd /etc/yum.repos.d
repofile="public-yum-ol7.repo"

if [ -f "$repofile" ]; then
  mv -f $repofile ${repofile}.${curdate}.orig
fi

wget --no-verbose http://yum.oracle.com/public-yum-ol7.repo

# modify the default ol7 file to enable uekr4 kernel. --------------------------
awk -f /tmp/scripts/oracle/enable_ol7_uekr4.awk $repofile > ${repofile}.${curdate}.uekr4
mv -f ${repofile}.${curdate}.uekr4 $repofile

# update the repository list. --------------------------------------------------
yum repolist

# install the latest ol7 updates. ----------------------------------------------
yum -y update

# install kernel development tools and headers for building guest additions. ---
yum -y install kernel-uek-devel
yum -y install kernel-uek

# remove package kit utility to turn-off auto-update of packages. --------------
yum -y remove PackageKit
