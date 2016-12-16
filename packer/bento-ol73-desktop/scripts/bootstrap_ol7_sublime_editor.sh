#!/bin/sh -eux
# install sublime text editor with associated gnome desktop app and images.

# install sublime text editor. -------------------------------------------------
sublimebinary="sublime_text_3_build_3126_x64.tar.bz2"
sublimefolder="sublime_text_3"

# create sublime home parent folder.
mkdir -p /usr/local/sublime_text
cd /usr/local/sublime_text

# download sublime binary.
wget --no-verbose https://download.sublimetext.com/${sublimebinary}

# extract sublime binary.
tar -jxvf ${sublimebinary}
chown -R root:root ./${sublimefolder}
rm -f ${sublimebinary}

# install sublime as gnome desktop app.
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

# update home folder references in sublime desktop file.
sed -i "s/\/opt\/sublime_text/\/usr\/local\/sublime_text\/${sublimefolder}/g" ./sublime_text.desktop

# install sublime desktop.
echo "Installing sublime_text.desktop..."
desktop-file-install --dir=/usr/share/applications/ ./sublime_text.desktop
update-desktop-database /usr/share/applications/
