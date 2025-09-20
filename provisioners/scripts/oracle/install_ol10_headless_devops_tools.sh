#!/bin/sh -eux
# install useful headless (command-line) developer tools on oracle linux 10.

# enable powertools repository. --------------------------------------------------------------------
dnf repolist

# install git. -------------------------------------------------------------------------------------
dnf -y install git
git --version
