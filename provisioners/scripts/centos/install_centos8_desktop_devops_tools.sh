#!/bin/sh -eux
# install useful gui developer tools.

# install 'gvim' graphical editor. -----------------------------------------------------------------
yum -y install vim-X11
gvim --version

# install useful system configuration edit tools. --------------------------------------------------
yum -y install dconf-editor
yum -y install gnome-shell-extension-desktop-icons
yum -y install gnome-tweaks
