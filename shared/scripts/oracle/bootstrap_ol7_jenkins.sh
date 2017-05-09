#!/bin/sh -eux
# install jenkins on oracle linux 7.x.

# update the repository list. --------------------------------------------------
yum repolist

# install jenkins platform. -----------------------------------------------------
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum -y install jenkins 

# display network configuration. -----------------------------------------------
ifconfig
