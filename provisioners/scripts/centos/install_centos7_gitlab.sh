#!/bin/sh -eux
# install gitlab git repository management platform on centos linux 7.x.

# install gitlab pre-requisites.
yum -y install curl policycoreutils-python openssh-server openssh-clients
#systemctl enable sshd
#systemctl start sshd
#firewall-cmd --permanent --add-service=http
#systemctl reload firewalld

# install postfix to send notification emails.
# If you want to use another solution to send emails, please skip this step and
# configure an external smtp server after gitlab has been installed.
#yum -y install postfix
#systemctl enable postfix
#systemctl start postfix

# install gitlab platform. -----------------------------------------------------
curl --silent https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
EXTERNAL_URL="http://10.0.2.15" yum -y install gitlab-ce
#yum -y install gitlab-ce

# configure gitlab.
#gitlab-ctl reconfigure

# display network configuration. -----------------------------------------------
#ip addr show
