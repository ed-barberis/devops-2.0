#!/bin/sh -eux
# install useful headless (command-line) developer tools.

# install epel repository. -------------------------------------------------------------------------
yum -y install epel-release

# install python 2.x pip and setuptools. -----------------------------------------------------------
yum -y install python-pip
python --version
pip --version

# upgrade python 2.x pip.
pip install --upgrade pip
pip --version

# install python 2.x setup tools.
yum -y install python-setuptools
pip install --upgrade setuptools
easy_install --version

# install software collections library. (needed later for python 3.x.) -----------------------------
yum -y install scl-utils
yum -y install centos-release-scl

# install git. -------------------------------------------------------------------------------------
yum -y install git
git --version

# install bash completion tools. -------------------------------------------------------------------
yum -y install bash-completion bash-completion-extras
