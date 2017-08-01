#!/bin/sh -eux
# install spring tool suite text editor with associated gnome desktop app and images.

# install spring tool suite ide. -----------------------------------------------
stsrelease="3.9.0"
stsnumber="1212372077"
eclipseversion="oxygen"
eclipserelease="4.7.0"

eclipsedist=$(echo "e${eclipserelease}" | awk -F "." '{printf "%s.%s", $1, $2}')
stsbinary="spring-tool-suite-${stsrelease}.RELEASE-e${eclipserelease}-linux-gtk-x86_64.tar.gz"
stsfolder="sts-bundle-${stsrelease}"

# create spring tool suite home parent folder.
mkdir -p /usr/local/spring
cd /usr/local/spring

# download spring tool suite binary.
wget --no-verbose http://download.springsource.com/release/STS/${stsrelease}.RELEASE/dist/${eclipsedist}/${stsbinary}

# extract spring tool suite binary.
tar -zxvf ${stsbinary} --no-same-owner --no-overwrite-dir
chown -R root:root ./sts-bundle
mv sts-bundle ${stsfolder}
ln -s ${stsfolder} sts-bundle
rm -f ${stsbinary}

# modify the sts config file. --------------------------------------------------
cd sts-bundle/sts-${stsrelease}.RELEASE
cp -p STS.ini STS.ini.orig

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d")

# set the default jdk and adjust the jvm heap.
awk -f /tmp/scripts/oracle/config_ol7_spring_tool_suite_eclipse_ide.awk STS.ini > STS.${curdate}.ini
mv -f STS.${curdate}.ini STS.ini

# create the default user workspace. -------------------------------------------
prefsfile="org.eclipse.ui.ide.prefs"
prefspath="/home/vagrant/.eclipse/org.springsource.sts_${stsrelease}.RELEASE_${stsnumber}_linux_gtk_x86_64/configuration/.settings"
wspath="/home/vagrant/workspaces/spring-sts-${stsrelease}-${eclipseversion}-${eclipserelease}"

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

# install spring tool suite as gnome desktop app. ------------------------------
imgname="spring-tool-suite-logo"
imgsizearray=( "16x16" "22x22" "24x24" "32x32" "48x48" "64x64" "128x128" "256x256" )
imgfolder="/usr/share/icons/hicolor"

cd /tmp/scripts/oracle

# install spring tool suite icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}-${imgsize}.png..."
    install -o root -g root -m 0644 ./images/${imgname}-${imgsize}.png ${imgfolder}/${imgsize}/apps/${imgname}.png
  fi
done

# install spring tool suite desktop in applications menu. ----------------------
echo "Installing spring-tool-suite.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/spring-tool-suite.desktop
update-desktop-database /usr/share/applications/

# install spring tool suite launcher on user desktop. --------------------------
echo "Installing spring-tool-suite.desktop on user desktop..."
mkdir -p /home/vagrant/Desktop
cd /home/vagrant/Desktop
cp -f /usr/share/applications/spring-tool-suite.desktop .

chown -R vagrant:vagrant .
chmod 755 ./spring-tool-suite.desktop
