#!/bin/sh -eux

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] sudoers configuration parameters [w/ defaults].
user_name="${user_name:-ubuntu}"                                            # [optional] user name.

# shellcheck disable=SC2024,SC2260
if ! sudo --version > /dev/stdout 2>&1 | grep -q sudo-rs; then
  sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers;
fi

# set up password-less sudo for the input user.
echo "${user_name} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99_${user_name};
chmod 440 /etc/sudoers.d/99_${user_name};

reboot
