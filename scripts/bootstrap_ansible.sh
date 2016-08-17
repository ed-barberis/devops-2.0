#!/bin/bash

# ----------------------------------------------------------------------
# NOTE: There is an issue automating the install of Guest Additions, so
#       you will need to manually complete these steps for now.
# ----------------------------------------------------------------------
#   $ vagrant up cd
#   $ vagrant ssh
#
#     $ cd .ssh
#     $ chmod 600 authorized_keys
#     $ exit
#
#   $ vagrant reload cd
#   $ vagrant ssh
#
#     $ sudo su -
#     # mkdir -p /tmp/vagrant
#     # cd /tmp/vagrant
#     # wget http://download.virtualbox.org/virtualbox/5.1.4/VBoxGuestAdditions_5.1.4.iso
#     # mkdir -p /mnt/VBoxGuestAdditions_5.1.4
#     # mount VBoxGuestAdditions_5.1.4.iso /mnt/VBoxGuestAdditions_5.1.4
#     # cd /mnt/VBoxGuestAdditions_5.1.4
#     # ./VBoxLinuxAdditions.run
#     # touch /tmp/vagrant/vbguest-updated.txt
#     # exit
#     $ exit
#
#   $ vagrant reload cd
#   $ vagrant vbguest --status cd
#   $ vagrant provision cd
#   $ vagrant ssh
#
#     $ git --version
#     $ ansible --version
#     $ docker --version
#     $ exit
#
#   $ vagrant halt
# ----------------------------------------------------------------------

set -e

# set oracle proxy environment variables (if needed).
#export http_proxy=http://www-proxy.us.oracle.com:80
#export https_proxy=http://www-proxy.us.oracle.com:80

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d")

# set helper variables to indicate progress between vagrant reloads
uekr3_version=3.10.0
uekr4_version=4.1.12
uek_version=/tmp/vagrant/uek-version.txt
vbguest_updated=/tmp/vagrant/vbguest-updated.txt

# report the current uek version.
mkdir -p /tmp/vagrant
echo ""
echo "-----------------------------------------------------------"
echo "Report the current kernel version..."
echo "-----------------------------------------------------------"
echo $(uname -r)
uname -r > $uek_version
echo "-----------------------------------------------------------"
echo ""

# if current version is uekr3, then upgrade to the uekr4 kernel.
if [ -f $uek_version ] && [[ $(uname -r) == *"${uekr3_version}"* ]]; then
  echo ""
  echo "-----------------------------------------------------------"
  echo "Upgrading to the UEKR4 kernel..."
  echo "-----------------------------------------------------------"
  # get the latest ol7 repository file.
  cd /etc/yum.repos.d
  repofile="public-yum-ol7.repo"

  if [ -f $repofile ];
  then
    mv -f $repofile ${repofile}.${curdate}.orig
  fi

  wget http://yum.oracle.com/public-yum-ol7.repo

  # modify the default ol7 file to enable uekr4 kernel.
  awk -f /vagrant/scripts/enable-ol7-uekr4.awk $repofile > ${repofile}.${curdate}.uekr4
  mv -f ${repofile}.${curdate}.uekr4 $repofile
  echo ""

  # update the repository list.
  echo "yum repolist"
  yum repolist
  echo ""

  # install the latest ol7 uekr4 updates.
  echo "yum -y update"
  yum -y update
  echo ""

  # install kernel development tools and headers for building guest additions.
  echo "yum -y install kernel-uek-devel"
  yum -y install kernel-uek-devel
  echo "yum -y install kernel-uek"
  yum -y install kernel-uek
  echo "yum -y install kernel-devel"
  yum -y install kernel-devel
  echo "yum -y install kernel-headers"
  yum -y install kernel-headers
  echo "yum -y install kernel"
  yum -y install kernel
  echo "-----------------------------------------------------------"
fi

# install the latest virtualbox guest additions.
#if [ -f $uek_version ] && [[ $(uname -r) == *"${uekr4_version}"* ]]; then
#  echo ""
#  echo "-----------------------------------------------------------"
#  echo "Install latest VirtualBox Guest Additions..."
#  echo "-----------------------------------------------------------"
#  # create temporary folder for the downloaded file.
#  mkdir -p /tmp/vagrant
#  cd /tmp/vagrant

#  # download the virtualbox guest additions iso file.
#  wget http://download.virtualbox.org/virtualbox/5.1.4/VBoxGuestAdditions_5.1.4.iso

#  # mount the iso image.
#  mkdir -p /mnt/VBoxGuestAdditions_5.1.4
#  mount VBoxGuestAdditions_5.1.4.iso /mnt/VBoxGuestAdditions_5.1.4

#  # run the virtualbox guest additions installer.
#  cd /mnt/VBoxGuestAdditions_5.1.4
#  ./VBoxLinuxAdditions.run

#  # touch help file to indicated guest additions updated.
#  touch $vbguest_updated
#  echo "-----------------------------------------------------------"
#fi

# install ansible.
if [ -f $vbguest_updated ]; then
  echo ""
  echo "-----------------------------------------------------------"
  echo "Installing Ansible..."
  echo "-----------------------------------------------------------"
  # create temporary folder for the downloaded file.
  mkdir -p /tmp/vagrant
  cd /tmp/vagrant

  # download and install the epel rpm package.
  wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  rpm -ivh epel-release-latest-7.noarch.rpm

  # update the repository list.
  echo "yum repolist"
  yum repolist
  echo ""

  # install ansible from the epel rpm package.
  echo "yum -y install ansible"
  yum -y install ansible

  # copy the ansible configuration file.
  cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg
  echo "-----------------------------------------------------------"
fi

# install docker.
if [ -f $vbguest_updated ]; then
  echo ""
  echo "-----------------------------------------------------------"
  echo "Installing Docker..."
  echo "-----------------------------------------------------------"
  # update the repository list.
  echo "yum repolist"
  yum repolist
  echo ""

  # install docker.
  echo "yum -y install docker-engine"
  yum -y install docker-engine
  echo "-----------------------------------------------------------"
fi

# install git.
echo ""
echo "-----------------------------------------------------------"
echo "Installing Git..."
echo "-----------------------------------------------------------"
# update the repository list.
echo "yum repolist"
yum repolist
echo ""

# install git.
echo "yum -y install git"
yum -y install git
echo "-----------------------------------------------------------"
echo ""

cd $HOME

#apt-get install -y software-properties-common
#apt-add-repository ppa:ansible/ansible
#apt-get update
#apt-get install -y --force-yes ansible
#cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg

#apt-get update -y
#apt-get install -y python-pip python-dev
#pip install ansible==1.9.2
#mkdir -p /etc/ansible
#touch /etc/ansible/hosts
#cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg
#mkdir -p /etc/ansible/callback_plugins/
#cp /vagrant/ansible/plugins/human_log.py /etc/ansible/callback_plugins/human_log.py
