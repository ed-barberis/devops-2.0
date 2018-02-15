#!/bin/sh -eux
# install gitlab git repository management platform on centos linux 7.x.

# install gitlab platform. -----------------------------------------------------
curl --silent https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
yum -y install gitlab-ce

# configure gitlab.
gitlab-ctl reconfigure

# display network configuration. -----------------------------------------------
ifconfig
