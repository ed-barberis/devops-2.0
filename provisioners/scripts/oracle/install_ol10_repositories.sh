#!/bin/sh -eux
# update the oracle linux 10 repositories.

# install shipped kernels. -------------------------------------------------------------------------
dnf search ol10_baseos_developer
dnf search ol10_appstream_developer
dnf search ol10_codeready_builder_developer
dnf search ol10_developer_UEKnext

# install useful base utilities. -------------------------------------------------------------------
dnf -y install yum-utils yum-plugin-versionlock bind-utils unzip vim-enhanced tree bc
dnf -y install openssh-clients sudo kernel-headers kernel-devel gcc make perl selinux-policy-devel wget nfs-utils net-tools bzip2
dnf -y install bash-completion

# install the latest os updates. -------------------------------------------------------------------
dnf -y upgrade
