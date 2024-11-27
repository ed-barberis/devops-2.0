#!/bin/sh -eux
# install useful headless (command-line) developer tools on oracle linux 9.

# install epel repository. -------------------------------------------------------------------------
dnf -y install epel-release

# enable powertools repository. --------------------------------------------------------------------
dnf config-manager --set-enabled ol9_codeready_builder
dnf repolist

# install neofetch system information tool. ---------------------------------------------------------
dnf -y install neofetch

# verify installation.
set +e  # temporarily turn 'exit pipeline on non-zero return status' OFF.
neofetch --version
set -e  # turn 'exit pipeline on non-zero return status' back ON.

# display system information.
neofetch

# install git. -------------------------------------------------------------------------------------
dnf -y install git
git --version
