#!/bin/sh -eux
# create new user groups on linux 64-bit distros using 'systemd'.

# set empty default values for user group env variables if not set. --------------------------------
user_groups="${user_groups:-}"
user_group_ids="${user_group_ids:-}"

# define usage function. ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
    [root]# export user_groups="group1 group2 group3"       # whitespace separated list of user group names.
    [root]# export user_group_ids="1001 1002 1003"          # [optional] whitespace separated list of user group ids.
    [root]# $0
EOF
}

# validate environment variables. ------------------------------------------------------------------
if [ -z "$user_groups" ]; then
  echo "Error: 'user_groups' environment variable not set."
  usage
  exit 1
fi

# initialize user group name and id arrays. --------------------------------------------------------
user_groups_array=( $user_groups )
user_groups_length=${#user_groups_array[@]}
user_group_ids_array=( $user_group_ids )
user_group_ids_length=${#user_group_ids_array[@]}

# if user group ids are present, do the number of user group names and ids match?
if [ -n "$user_group_ids" ]; then
  if [ ! "$user_groups_length" -eq "$user_group_ids_length" ];then
    echo "Error: Number of 'user_groups' and 'user_group_ids' must be equal."
    usage
    exit 1
  fi
fi

# loop to create each user group. ------------------------------------------------------------------
ii=0                                                        # initialize array index.
for user_group in "${user_groups_array[@]}"; do
  # check for custom user group ids.
  if [ -n "$user_group_ids" ]; then
    groupadd -g ${user_group_ids_array[$ii]} ${user_group}
  else
    groupadd ${user_group}
  fi

  ii=$(($ii + 1))                                           # increment array index.
done
