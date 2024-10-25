#!/bin/sh -eux
# install python 3.6 from the software collection library for linux 7.x..

# install python 3.x. ------------------------------------------------------------------------------
yum -y install python3
alternatives --set python /usr/bin/python3

# verify installation.
python3 --version
python --version

# install python 3.x pip. --------------------------------------------------------------------------
yum -y install python3-pip
#alternatives --set pip /usr/bin/pip3

# verify installation.
pip3 --version
#pip --version

# upgrade python 3.x pip.
#python3 -m pip install --upgrade pip
#pip3 --version
