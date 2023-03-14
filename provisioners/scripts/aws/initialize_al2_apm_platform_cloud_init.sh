#!/bin/sh -eux
# appdynamics apm cloud-init script to initialize amazon linux 2 vm imported from ami.

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] aws user and host name config parameters [w/ defaults].
user_name="${user_name:-centos}"
aws_ec2_hostname="${aws_ec2_hostname:-apm}"
aws_ec2_domain="${aws_ec2_domain:-localdomain}"

# configure public keys for specified user. --------------------------------------------------------
user_authorized_keys_file="/home/${user_name}/.ssh/authorized_keys"
user_key_name="devops-2.0"
user_public_key="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAk5kFiJyh5qsfrjthhp00TH5TfPptKGvGdhhWQN4XLMxHfJgx0T0BDEAGX0B3VzjxjPXtr1vRD+7V9A6RfouSK6u/Vii2pRe9483nq3gWuJvKLSHWRa7QowwndsuTdb1HUKcxsmu6uRjZph5fXroLxpoiPoBwj+eHIWq+lAcxHOp7etQqceXhj4eUcJ40xzyk1UpxYXac/QDojG1EG4N3V9EWOmPFr3XdPGAXl6+61bsWmll614QqFHPVoLQ8D/Bss2P/dCiPJEJRkmmVdppwn6sn0B2mABaiUsvNEFFP8rPUqsWJIAqEZV8SY23VAkLrgipAceQn9VnJKB6XomCQ2Q== devops-2.0"

# 'grep' to see if the user's public key is already present, if not, append to the file.
grep -qF "${user_key_name}" ${user_authorized_keys_file} || echo "${user_public_key}" >> ${user_authorized_keys_file}
chmod 600 ${user_authorized_keys_file}

# delete public key inserted by packer during the ami build.
sed -i -e "/packer/d" ${user_authorized_keys_file}

# configure the hostname of the aws ec2 instance. --------------------------------------------------
# export environment variables.
export aws_ec2_hostname
export aws_ec2_domain

# set the hostname.
./config_al2_system_hostname.sh
