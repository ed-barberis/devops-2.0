#!/bin/sh -eux
# install scala ide for eclipse text editor with associated gnome desktop app and images.

# install scala ide. -----------------------------------------------------------
idehome="scala-ide"
iderelease="4.6.1"
idenumber="212-20170609"
scalarelease="2.12"
eclipseversion="neon"
eclipserelease="4.6.3"
eclipsenumber="1670605982"

idebinary="scala-SDK-${iderelease}-vfinal-${scalarelease}-linux.gtk.x86_64.tar.gz"
idefolder="scala-ide-${iderelease}"

# create scala home parent folder.
mkdir -p /usr/local/scala
cd /usr/local/scala

# download scala ide binary.
wget --no-verbose http://downloads.typesafe.com/scalaide-pack/${iderelease}-vfinal-${eclipseversion}-${idenumber}/${idebinary}

# extract scala ide binary.
tar -zxvf ${idebinary} --no-same-owner --no-overwrite-dir
mv -f eclipse ${idefolder}
chown -R root:root ./${idefolder}
ln -s ${idefolder} ${idehome}
rm -f ${idebinary}

# modify the scala ide config file. --------------------------------------------
cd ${idehome}
cp -p eclipse.ini eclipse.ini.orig

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d")

# set the default jdk and adjust the jvm heap.
awk -f /tmp/scripts/oracle/config_ol7_scala_ide_for_eclipse.awk eclipse.ini > eclipse.${curdate}.ini
mv -f eclipse.${curdate}.ini eclipse.ini

# create the default user workspace. -------------------------------------------
prefsfile="org.eclipse.ui.ide.prefs"
prefspath="/home/vagrant/.eclipse/org.eclipse.platform_${eclipserelease}_${eclipsenumber}_linux_gtk_x86_64/configuration/.settings"
wspath="/home/vagrant/workspaces/scala-ide-${iderelease}-${eclipseversion}-${scalarelease}"

# create the ide preferences file.
mkdir -p ${prefspath}
cd ${prefspath}
touch ${prefsfile}
chmod 644 ${prefsfile}

echo "MAX_RECENT_WORKSPACES=10" >> ${prefsfile}
echo "RECENT_WORKSPACES=${wspath}" >> ${prefsfile}
echo "RECENT_WORKSPACES_PROTOCOL=3" >> ${prefsfile}
echo "SHOW_RECENT_WORKSPACES=false" >> ${prefsfile}
echo "SHOW_WORKSPACE_SELECTION_DIALOG=true" >> ${prefsfile}
echo "eclipse.preferences.version=1" >> ${prefsfile}

cd /home/vagrant/.eclipse
chown -R vagrant:vagrant .

# create the ide workspace folder.
mkdir -p ${wspath}
cd /home/vagrant/workspaces
chown -R vagrant:vagrant .

# install scala ide as gnome desktop app. --------------------------------------
imgname="scala-ide-for-eclipse-logo"
imgsizearray=( "16x16" "22x22" "24x24" "32x32" "48x48" "64x64" "128x128" "256x256" )
imgfolder="/usr/share/icons/hicolor"

cd /tmp/scripts/oracle

# install scala ide icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}-${imgsize}.png..."
    install -o root -g root -m 0644 ./images/${imgname}-${imgsize}.png ${imgfolder}/${imgsize}/apps/${imgname}.png
  fi
done

# install scala ide desktop in applications menu. ------------------------------
echo "Installing scala-ide-for-eclipse.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/scala-ide-for-eclipse.desktop
update-desktop-database /usr/share/applications/

# install scala ide launcher on user desktop. ----------------------------------
echo "Installing scala-ide-for-eclipse.desktop on user desktop..."
mkdir -p /home/vagrant/Desktop
cd /home/vagrant/Desktop
cp -f /usr/share/applications/scala-ide-for-eclipse.desktop .

chown -R vagrant:vagrant .
chmod 755 ./scala-ide-for-eclipse.desktop
