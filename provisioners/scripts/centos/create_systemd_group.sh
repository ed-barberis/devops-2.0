#!/bin/bash -eux
# create new user group on linux 64-bit distros using 'systemd'.

# set empty default values for user group env variables if not set. --------------------------------
user_group="${user_group:-}"
user_group_id="${user_group_id:-}"

# define usage function. ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
    [root]# export user_group="group1"                      # user group name.
    [root]# export user_group_id="1001"                     # [optional] user group id.
    [root]# $0
EOF
}

# validate environment variables. ------------------------------------------------------------------
if [ -z "$user_group" ]; then
  echo "Error: 'user_group' environment variable not set."
  usage
  exit 1
fi

# create user group. -------------------------------------------------------------------------------
# check for custom user group id.
if [ -n "$user_group_id" ]; then
  groupadd -g ${user_group_id} ${user_group}
else
  groupadd ${user_group}
fi
