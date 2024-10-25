#!/bin/sh -eux
# install useful headless (command-line) developer tools.

# install epel repository. -------------------------------------------------------------------------
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

# install python 2.x pip and setuptools. -----------------------------------------------------------
#yum -y install python2-pip
#python2 --version
#pip2 --version

# upgrade python 2.x pip.
#python2 -m pip install --upgrade pip
#pip2 --version

# install python 2.x setup tools.
#yum -y install python2-setuptools
#python2 -m pip install --upgrade setuptools
#easy_install --version

# install git. -------------------------------------------------------------------------------------
yum -y install git
git --version

# install bash completion tools. -------------------------------------------------------------------
yum -y install bash-completion
