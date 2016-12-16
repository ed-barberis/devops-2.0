#!/bin/sh -eux
# install adobe brackets text editor with associated gnome desktop app and images.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# install adobe brackets text editor. -------------------------------------------------
bracketsbinary="brackets-1.7.0-1.el7.nux.x86_64.rpm"
bracketsfolder="/usr/share/brackets"

# download brackets repository.
wget --no-verbose ftp://ftp.pbone.net/mirror/li.nux.ro/download/nux/dextop/el7/x86_64/${bracketsbinary}
yum repolist
yum -y install ${bracketsbinary}

# install brackets as gnome desktop app.
imgname="appshell"
imgsizearray=( "32" "48" "128" "256" )
imgfolder="/usr/share/icons/hicolor"

cd ${bracketsfolder}

# install brackets icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}${imgsize}.png..."
    install -o root -g root -m 0644 ./${imgname}${imgsize}.png ${imgfolder}/${imgsize}x${imgsize}/apps/brackets.png
  fi
done

# update home folder references in brackets desktop file.
sed -i "s/\/opt\/brackets/\/usr\/share\/brackets/g;s/Categories=Development/Categories=TextEditor;Development;/g" ./brackets.desktop

# install brackets desktop.
echo "Installing brackets.desktop..."
desktop-file-install --dir=/usr/share/applications/ ./brackets.desktop
update-desktop-database /usr/share/applications/
