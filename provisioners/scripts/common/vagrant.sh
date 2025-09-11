#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
OS_NAME=$(uname -s)
if [ "$OS_NAME" = "Darwin" ]; then
  HOME_DIR="/Users/vagrant"
else
  HOME_DIR="${HOME_DIR:-/home/vagrant}"
fi

if command -v ping > /dev/null 2>&1; then
  echo "Pinging raw.githubusercontent.com"
  if ! ping -c 1 raw.githubusercontent.com > /dev/null 2>&1; then
    echo "Ping failed, sleeping for 30 seconds"
    sleep 30;
  fi
else
  echo "Cannot ping, sleeping for 30 seconds"
  sleep 30;
fi

pubkey_url="https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub"
mkdir -p "$HOME_DIR"/.ssh
if command -v curl > /dev/null 2>&1; then
  curl --insecure --location "$pubkey_url" > "$HOME_DIR"/.ssh/authorized_keys && \
  echo "Successfully downloaded vagrant public key with curl"
elif command -v wget > /dev/null 2>&1; then
  wget --no-check-certificate "$pubkey_url" -O "$HOME_DIR"/.ssh/authorized_keys && \
  echo "Successfully downloaded vagrant public key with wget"
elif command -v fetch > /dev/null 2>&1; then
  fetch -am -o "$HOME_DIR"/.ssh/authorized_keys "$pubkey_url" && \
  echo "Successfully downloaded vagrant public key with fetch"
else
    echo "Cannot download vagrant public key"
    exit 1
fi
chown -R vagrant "$HOME_DIR"/.ssh
chmod -R go-rwsx "$HOME_DIR"/.ssh

personal_pubkey_url="https://raw.githubusercontent.com/ed-barberis/devops-2.0/refs/heads/master/shared/keys/EdBarberis.pub"
personal_pubkey_file="/tmp/personal_public_key"
mkdir -p "$HOME_DIR"/.ssh
rm -f ${personal_pubkey_file}
if command -v curl > /dev/null 2>&1; then
  curl --insecure --location "$personal_pubkey_url" > ${personal_pubkey_file} && \
  echo "Successfully downloaded personal public key with curl"
elif command -v wget > /dev/null 2>&1; then
  wget --no-check-certificate "$personal_pubkey_url" -O ${personal_pubkey_file} && \
  echo "Successfully downloaded personal public key with wget"
elif command -v fetch > /dev/null 2>&1; then
  fetch -am -o ${personal_pubkey_file} "$personal_pubkey_url" && \
  echo "Successfully downloaded personal public key with fetch"
else
    echo "Cannot download personal public key"
    exit 1
fi
cat ${personal_pubkey_file} >> "$HOME_DIR"/.ssh/authorized_keys && \
echo "Successfully added personal public key to 'authorized_keys' file."
chown -R vagrant "$HOME_DIR"/.ssh
chmod -R go-rwsx "$HOME_DIR"/.ssh
