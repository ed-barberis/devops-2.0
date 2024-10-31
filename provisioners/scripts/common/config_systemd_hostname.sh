#!/bin/sh -eux
# configure the hostname of a systemd-based vm instance.

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] hostname config parameters [w/ defaults].
vm_hostname="${vm_hostname:-lpad}"
vm_domain="${vm_domain:-localdomain}"

# set the system hostname. -------------------------------------------------------------------------
hostnamectl set-hostname "${vm_hostname}.${vm_domain}" --static
hostnamectl set-hostname "${vm_hostname}.${vm_domain}"

# verify configuration.
hostnamectl status

# modify system network configuration. -------------------------------------------------------------
network_config_file="/etc/sysconfig/network"

if [ -f "$network_config_file" ]; then
  cp -p $network_config_file ${network_config_file}.orig

  # set the 'hostname' entry if not set.
  if [ $(grep -c '^HOSTNAME' "$network_config_file") -eq 0 ]; then
    echo "HOSTNAME=${vm_hostname}.${vm_domain}" >> ${network_config_file}
  else
    sed -i -e "/^HOSTNAME/s/^.*$/HOSTNAME=${vm_hostname}.${vm_domain}/" ${network_config_file}
  fi

  # verify configuration.
  grep '^HOSTNAME' "$network_config_file"
fi

# modify system hosts file. ------------------------------------------------------------------------
system_hosts_file="/etc/hosts"

if [ -f "$system_hosts_file" ]; then
  cp -p $system_hosts_file ${system_hosts_file}.orig

  # set the 'hostname' entry if not set.
  if [ $(grep -c "${vm_hostname}" "$system_hosts_file") -eq 0 ]; then
    sed -i -e "1i\127.0.0.1   ${vm_hostname}.${vm_domain} ${vm_hostname}" ${system_hosts_file}
  else
    sed -i -e "/${vm_hostname}/s/^.*$/127.0.0.1   ${vm_hostname}.${vm_domain} ${vm_hostname}/" ${system_hosts_file}
  fi

  # verify configuration.
  grep "$vm_hostname" "$system_hosts_file"
fi
