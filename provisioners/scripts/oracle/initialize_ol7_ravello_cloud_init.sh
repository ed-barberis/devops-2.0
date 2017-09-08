#!/bin/sh -eux
# ravello cloud-init script to initialize oracle linux 7 vm imported from virtualbox.

# enable 'eth0' network connection. --------------------------------------------
# note: oracle linux 7 enp0s3 and enp0s8 devices are not supported in ravello.
nmcli device status
nmcli connection add con-name "eth0" type ethernet ifname eth0

# add public key for vagrant 'devops-2.0' user. --------------------------------
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAk5kFiJyh5qsfrjthhp00TH5TfPptKGvGdhhWQN4XLMxHfJgx0T0BDEAGX0B3VzjxjPXtr1vRD+7V9A6RfouSK6u/Vii2pRe9483nq3gWuJvKLSHWRa7QowwndsuTdb1HUKcxsmu6uRjZph5fXroLxpoiPoBwj+eHIWq+lAcxHOp7etQqceXhj4eUcJ40xzyk1UpxYXac/QDojG1EG4N3V9EWOmPFr3XdPGAXl6+61bsWmll614QqFHPVoLQ8D/Bss2P/dCiPJEJRkmmVdppwn6sn0B2mABaiUsvNEFFP8rPUqsWJIAqEZV8SY23VAkLrgipAceQn9VnJKB6XomCQ2Q== devops-2.0" >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys

# disable ssh password authentication. -----------------------------------------
sshdconfig="/etc/ssh/sshd_config"

# check if sshd config file exists.
if [ -f "${sshdconfig}" ]; then
  cp -p ${sshdconfig} ${sshdconfig}.orig

  # modify sshd config file and restart ssh daemon.
  sed -i -e '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' ${sshdconfig}
  sed -i -e '/^#RSAAuthentication/s/^.*$/RSAAuthentication yes/' ${sshdconfig}
  sed -i -e '/^#PubkeyAuthentication/s/^.*$/PubkeyAuthentication yes/' ${sshdconfig}
  systemctl restart sshd
fi

# install and configure acpi daemon with shutdown optimizations. ---------------
# install and enable the acpi daemon.
yum -y install acpid
systemctl start acpid
systemctl enable acpid

# initialize acpi power script file paths.
acpiconfig="/etc/acpi/actions/power.sh"
acpitmp="/tmp/power.sh.awk"

# check if acpi power script file exists.
if [ -f "${acpiconfig}" ]; then
  cp -p ${acpiconfig} ${acpiconfig}.orig
  rm -f ${acpitmp}
  touch ${acpitmp}

  # modify acpi power script file and restart acpi daemon.
  awk '{if ($0 ~ /^PATH/) {printf "%s\n\n# Changed to enable immediate shutdown in Ravello.\nshutdown -h now\n", $0} else {print $0}}' ${acpiconfig} >> ${acpitmp}
  mv -f ${acpitmp} ${acpiconfig}
  systemctl restart acpid
fi
