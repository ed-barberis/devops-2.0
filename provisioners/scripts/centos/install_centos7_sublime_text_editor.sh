#!/bin/sh -eux
# install sublime text editor with associated gnome desktop app and images.

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# install sublime text editor. -------------------------------------------------
sublimerelease="3211"
sublimefolder="sublime_text_3"
sublimebinary="${sublimefolder}_build_${sublimerelease}_x64.tar.bz2"

# create sublime home parent folder.
mkdir -p /usr/local/sublime_text
cd /usr/local/sublime_text

# download sublime binary.
wget --no-verbose https://download.sublimetext.com/${sublimebinary}

# extract sublime binary.
tar -jxvf ${sublimebinary}
chown -R root:root ./${sublimefolder}
rm -f ${sublimebinary}

# install sublime as gnome desktop app. ----------------------------------------
imgname="sublime-text"
imgsizearray=( "16x16" "32x32" "48x48" "128x128" "256x256" )
imgfolder="/usr/share/icons/hicolor"

cd /usr/local/sublime_text/${sublimefolder}

# install sublime icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}.png..."
    install -o root -g root -m 0644 ./Icon/${imgsize}/${imgname}.png ${imgfolder}/${imgsize}/apps/${imgname}.png
  fi
done

# update home folder and icon references in sublime desktop file.
sed -i "s/\/opt\/sublime_text/\/usr\/local\/sublime_text\/${sublimefolder}/g;s/sublime-text/\/usr\/share\/icons\/hicolor\/128x128\/apps\/sublime-text.png/g" ./sublime_text.desktop

# install sublime desktop in applications menu. --------------------------------
echo "Installing sublime_text.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./sublime_text.desktop
update-desktop-database /usr/share/applications/

# copy sublime launcher to devops applications folder. -------------------------
echo "Copying sublime_text.desktop launcher to devops 'applications' folder..."
mkdir -p ${devops_home}/provisioners/scripts/centos/applications
cd ${devops_home}/provisioners/scripts/centos/applications
cp -f /usr/share/applications/sublime_text.desktop .
chmod 755 ./sublime_text.desktop
