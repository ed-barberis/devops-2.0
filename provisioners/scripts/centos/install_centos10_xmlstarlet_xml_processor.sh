#!/bin/sh -eux
# install xmlstarlet command-line xml processor for centos 10.

# install epel repository (if needed). -------------------------------------------------------------
dnf config-manager --set-enabled crb
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm

# install xmlstarlet xml processor. ----------------------------------------------------------------
dnf -y install xmlstarlet

# verify installation.
xmlstarlet --version
