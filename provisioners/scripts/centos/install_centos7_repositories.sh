#!/bin/sh -eux
# update the centos linux 7 repositories.

# install epel repository if needed. ---------------------------------------------------------------
if [ ! -f "/etc/yum.repos.d/epel.repo" ]; then
  rm -f /tmp/epel-release-7-14.noarch.rpm
# rm -f /tmp/epel-release-latest-7.noarch.rpm
  curl --silent --location https://archives.fedoraproject.org/pub/archive/epel/7/x86_64/Packages/e/epel-release-7-14.noarch.rpm --output /tmp/epel-release-7-14.noarch.rpm
# curl --silent --location https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm --output /tmp/epel-release-latest-7.noarch.rpm
  yum -y install /tmp/epel-release-7-14.noarch.rpm
# yum -y install /tmp/epel-release-latest-7.noarch.rpm
fi

# centos linux 7 reached eol on July 1, 2024, so 'mirrorlist.centos.org' no longer exists.
# in order to install packages, you have to adjust repositories from 'mirrorlist' to 'baseurl'.
# for most cases 'vault.centos.org' will work well.
sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo

# install the latest os updates. -------------------------------------------------------------------
yum -y update

# remove package kit utility to turn-off auto-update of packages. ----------------------------------
yum -y remove PackageKit
