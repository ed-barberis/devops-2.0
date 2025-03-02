#!/bin/bash -eux
# install python 3.8 on ubuntu linux.

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] python 3.8 install parameters [w/ defaults].
user_name="${user_name:-vagrant}"

# define usage function. ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
    [root]# export user_name="vagrant"                          # user name.
    [root]# $0
EOF
}

# validate environment variables. ------------------------------------------------------------------
if [ -z "$user_name" ]; then
  echo "Error: 'user_name' environment variable not set."
  usage
  exit 1
fi

if [ "$user_name" = "root" ]; then
  echo "Error: 'user_name' should NOT be 'root'."
  usage
  exit 1
fi

# update the apt repository package indexes. -------------------------------------------------------
apt-get update

# install python 3.8, pip3, and setuptools. ---------------------------------------------------------
# install python3.8.
apt-get -y install python3.8 python3.8-dev python3.8-examples python3.8-venv

# set python3.8 home environment variables.
PATH=/usr/bin:$PATH
export PATH

# verify installation.
python3.8 --version

# upgrade pip3 and setuptools, etc. ----------------------------------------------------------------
# upgrade pip3 in the user's home account.
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3.8 -m pip install pip --upgrade --user" - ${user_name}
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} pip3 --version" - ${user_name}

# upgrade setuptools in the user's home account.
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3.8 -m pip install setuptools --user" - ${user_name}
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3.8 -m pip install setuptools --upgrade --user" - ${user_name}

# install pip 3.8 wheel.
# install and upgrade wheel in the user's home account.
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3.8 -m pip install wheel --user" - ${user_name}
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3.8 -m pip install wheel --upgrade --user" - ${user_name}

# install python 3.8 lxml xml and html python library.
# install and upgrade lxml in the user's home account.
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3.8 -m pip install lxml --user" - ${user_name}
runuser -c "PATH=/home/${user_name}/.local/bin:/usr/local/bin:${PATH} python3.8 -m pip install lxml --upgrade --user" - ${user_name}
