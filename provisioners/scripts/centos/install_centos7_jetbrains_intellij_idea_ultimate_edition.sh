#!/bin/sh -eux
# install intellij idea ultimate edition by jetbrains.

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# install intellij idea ultimate edition. --------------------------------------
idea_home="idea-IU"
idea_release="2018.2.1"
idea_build="182.3911.36"

idea_binary="ideaIU-${idea_release}-no-jdk.tar.gz"
#idea_binary="ideaIU-${idea_release}.tar.gz"
idea_folder="idea-IU-${idea_build}"

# create jetbrains home parent folder.
mkdir -p /usr/local/jetbrains
cd /usr/local/jetbrains

# download intellij idea ultimate edition binary.
wget --no-verbose https://download.jetbrains.com/idea/${idea_binary}

# extract intellij idea ultimate edition binary.
rm -f ${idea_home}
tar -zxvf ${idea_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${idea_folder}
ln -s ${idea_folder} ${idea_home}
rm -f ${idea_binary}

# install intellij idea ultimate edition as gnome desktop app. -----------------
imgname="intellij-idea-logo"
imgsizearray=( "16x16" "22x22" "24x24" "32x32" "48x48" "64x64" "128x128" "256x256" )
imgfolder="/usr/share/icons/hicolor"

cd ${devops_home}/provisioners/scripts/centos

# install intellij idea ultimate edition icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}-${imgsize}.png..."
    install -o root -g root -m 0644 ./images/${imgname}-${imgsize}.png ${imgfolder}/${imgsize}/apps/${imgname}.png
  fi
done

# install intellij idea ultimate edition desktop in applications menu. ---------
echo "Installing intellij-idea-ultimate.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/intellij-idea-ultimate.desktop
update-desktop-database /usr/share/applications/

# copy intellij idea ultimate edition launcher to devops applications folder. --
echo "Copying intellij-idea-ultimate.desktop launcher to devops 'applications' folder..."
mkdir -p ${devops_home}/provisioners/scripts/centos/applications
cd ${devops_home}/provisioners/scripts/centos/applications
cp -f /usr/share/applications/intellij-idea-ultimate.desktop .
chmod 755 ./intellij-idea-ultimate.desktop
