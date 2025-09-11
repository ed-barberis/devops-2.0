#!/bin/sh -eux
# install jenkins on centos linux 7.x.

# install jenkins platform. -----------------------------------------------------
wget --no-verbose --output-document /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum -y install jenkins

# modify jenkins configuration. ------------------------------------------------
jenkinsconfig="/etc/sysconfig/jenkins"

# check if jenkins config file exists.
if [ -f "${jenkinsconfig}" ]; then
  cp -p ${jenkinsconfig} ${jenkinsconfig}.orig

  # modify jenkins config file.
  sed -i -e '/^JENKINS_JAVA_CMD/s/^.*$/JENKINS_JAVA_CMD="\/usr\/local\/java\/jdk17\/bin\/java"/' ${jenkinsconfig}
  sed -i -e '/^JENKINS_PORT/s/^.*$/JENKINS_PORT="9080"/' ${jenkinsconfig}
fi

# start and enable jenkins daemon. ---------------------------------------------
systemctl start jenkins
systemctl enable jenkins

# display network configuration. -----------------------------------------------
#ip addr show
