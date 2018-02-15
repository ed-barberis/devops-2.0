#!/bin/sh -eux
# install adobe brackets text editor with associated gnome desktop app and images.

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# create scripts directory (if needed). ----------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# install adobe brackets text editor. ------------------------------------------
bracketsbinary="brackets-1.7.0-1.el7.nux.x86_64.rpm"
bracketsfolder="/usr/share/brackets"

# download brackets repository.
wget --no-verbose ftp://ftp.pbone.net/mirror/li.nux.ro/download/nux/dextop/el7/x86_64/${bracketsbinary}
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

# update home folder and category references in brackets desktop file.
sed -i "s/\/opt\/brackets/\/usr\/share\/brackets/g;s/Categories=Development/Categories=TextEditor;Development;/g" ./brackets.desktop

# install brackets desktop in applications menu.
echo "Installing brackets.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./brackets.desktop
update-desktop-database /usr/share/applications/

# install brackets launcher on user desktop.
echo "Installing brackets.desktop on user desktop..."
mkdir -p /home/vagrant/Desktop
cd /home/vagrant/Desktop
cp -f /usr/share/applications/brackets.desktop .

chown -R vagrant:vagrant .
chmod 755 ./brackets.desktop
