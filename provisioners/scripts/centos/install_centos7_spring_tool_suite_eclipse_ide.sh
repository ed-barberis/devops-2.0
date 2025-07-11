#!/bin/sh -eux
# install spring tool suite text editor with associated gnome desktop app and images.
# NOTE: if the sts release is updated, you will also need to update the sts release path
#       in the companion 'desktops/spring-tool-suite.desktop' file.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install spring tool suite ide. -------------------------------------------------------------------
sts_home="sts"
sts_release="4.31.0"
sts_number="173685548"
eclipse_version="2025-06"
eclipse_release="4.36.0"
eclipse_dist=$(echo "e${eclipse_release}" | awk -F "." '{printf "%s.%s", $1, $2}')
sts_family="${sts_release:0:1}"
sts_folder="${sts_home}-${sts_release}.RELEASE"
sts_config="SpringToolSuite${sts_family}.ini"

# set the go binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  sts_binary="spring-tool-suite-${sts_family}-${sts_release}.RELEASE-e${eclipse_release}-linux.gtk.x86_64.tar.gz"
  sts_sha256="c6f0022b24615e6d49eec4e447665f84c5a5af34ee3a29d7ede55d63e0e892ea"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  sts_binary="spring-tool-suite-${sts_family}-${sts_release}.RELEASE-e${eclipse_release}-linux.gtk.aarch64.tar.gz"
  sts_sha256="5111f54ce42ba4fa9d9465c933ab5e5b903dcd2472a6540ba048838dc8169383"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create spring tool suite home parent folder.
mkdir -p /usr/local/spring
cd /usr/local/spring

# download spring tool suite binary.
wget --no-verbose https://cdn.spring.io/spring-tools/release/STS${sts_family}/${sts_release}.RELEASE/dist/${eclipse_dist}/${sts_binary}

# verify the downloaded binary.
echo "${sts_sha256} ${sts_binary}" | sha256sum --check
# spring-tool-suite-${sts_family}-${sts_release}.RELEASE-e${eclipse_release}-linux.gtk.x86_64.tar.gz: OK

# extract spring tool suite binary.
rm -f ${sts_home}
tar -zxvf ${sts_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${sts_folder}
ln -s ${sts_folder} ${sts_home}
rm -f ${sts_binary}

# modify the spring tool suite config file. --------------------------------------------------------
cd ${sts_home}
cp -p ${sts_config} ${sts_config}.orig

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# set the default jdk and adjust the jvm heap.
awk -f ${devops_home}/provisioners/scripts/centos/config_centos7_spring_tool_suite_eclipse_ide.awk ${sts_config} > ${sts_config:0:-4}.${curdate}.ini
mv -f  ${sts_config:0:-4}.${curdate}.ini ${sts_config}

# create the default user workspace. ---------------------------------------------------------------
prefsfile="org.eclipse.ui.ide.prefs"
prefspath="/home/vagrant/.eclipse/org.eclipse.platform_${eclipse_release}_${sts_number}_linux_gtk_x86_64/configuration/.settings"
wspath="/home/vagrant/workspaces/spring-sts${sts_family}-${sts_release}-${eclipse_version}-${eclipse_release}"

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

# install spring tool suite as gnome desktop app. --------------------------------------------------
imgname="spring-tools-4-logo"
imgsizearray=( "16x16" "22x22" "24x24" "32x32" "48x48" "64x64" "128x128" "256x256" )
imgfolder="/usr/share/icons/hicolor"

cd ${devops_home}/provisioners/scripts/centos

# install spring tool suite icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}-${imgsize}.png..."
    install -o root -g root -m 0644 ./images/${imgname}-${imgsize}.png ${imgfolder}/${imgsize}/apps/${imgname}.png
  fi
done

# install spring tool suite desktop in applications menu. ------------------------------------------
echo "Installing spring-tool-suite.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/spring-tool-suite.desktop
update-desktop-database /usr/share/applications/

# copy spring tool suite launcher to devops applications folder. -----------------------------------
echo "Copying spring-tool-suite.desktop launcher to devops 'applications' folder..."
mkdir -p ${devops_home}/provisioners/scripts/centos/applications
cd ${devops_home}/provisioners/scripts/centos/applications
cp -f /usr/share/applications/spring-tool-suite.desktop .
chmod 755 ./spring-tool-suite.desktop
