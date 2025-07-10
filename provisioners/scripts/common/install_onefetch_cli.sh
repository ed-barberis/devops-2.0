#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Onefetch CLI tool for Linux 64-bit.
#
# Onefetch is a command-line Git information tool written in Rust that displays project information
# and code statistics for a local Git repository directly to your terminal. The tool is completely
# offline--no network access is required.
#
# Onefetch can be configured via command-line flags to display exactly what you want, the way you
# want it to: you can customize ASCII/Text formatting, disable info lines, ignore files and
# directories, output in multiple formats (Json, Yaml), etc.
#
# NOTE: this script uses the 'jq' command-line json processor utility for formatting the output returned by the AWS CLI.
#
# For more details, please visit:
#   https://github.com/o2sh/onefetch
#   https://github.com/o2sh/onefetch/wiki/installation
#   https://github.com/o2sh/onefetch/wiki/getting-started
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] onefetch install parameters [w/ defaults].
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

# validate that needed rust toolchain utilities are installed. -------------------------------------
# check if 'rustc' command-line utility is installed.
path_to_rustc=$(runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} which rustc" - ${user_name})
if [ ! -x "$path_to_rustc" ] ; then
  set +x  # temporarily turn command display OFF.
  echo "Error: 'rustc' command-line utility not found."
  echo "NOTE: This script requires the 'rustc' command-line utility to build 'onefetch' from source."
  echo "      For more information, visit: https://github.com/o2sh/onefetch/wiki/installation"
  set -x  # turn command display back ON.
  exit 1
fi

# check if 'cmake' command-line utility is installed.
path_to_cmake=$(runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} which cmake" - ${user_name})
if [ ! -x "$path_to_cmake" ] ; then
  set +x  # temporarily turn command display OFF.
  echo "Error: 'cmake' command-line utility not found."
  echo "NOTE: This script requires the 'cmake' command-line utility to build 'onefetch' from source."
  echo "      For more information, visit: https://github.com/o2sh/onefetch/wiki/installation"
  set -x  # turn command display back ON.
  exit 1
fi

# check if 'cargo' command-line utility is installed.
path_to_cargo=$(runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} which cargo" - ${user_name})
if [ ! -x "$path_to_cargo" ] ; then
  set +x  # temporarily turn command display OFF.
  echo "Error: 'cargo' command-line utility not found."
  echo "NOTE: This script requires the 'cargo' command-line utility to build 'onefetch' from source."
  echo "      For more information, visit: https://github.com/o2sh/onefetch/wiki/installation"
  set -x  # turn command display back ON.
  exit 1
fi

# install onefetch cli tool. -----------------------------------------------------------------------
runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} cargo install onefetch" - ${user_name}

# verify installation.
runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} onefetch --version" - ${user_name}
