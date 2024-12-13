#!/bin/sh -eux
# install intellij idea community edition by jetbrains.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install intellij idea community edition. ---------------------------------------------------------
idea_home="idea-IC"
idea_release="2024.3.1"
idea_build="243.22562.145"
idea_folder="idea-IC-${idea_build}"

# set the idea binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  idea_binary="ideaIC-${idea_release}.tar.gz"
  idea_sha256="b3fbdba793ba9e7800ac1ee4ceedf4726f86d5320c7c0d4e155b5bd10a296777"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  idea_binary="ideaIC-${idea_release}-aarch64.tar.gz"
  idea_sha256="dc3427884cc1b98cd79d152b9d808a72b99f751dc627063148dce862853819d4"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create jetbrains home parent folder.
mkdir -p /usr/local/jetbrains
cd /usr/local/jetbrains

# download intellij idea community edition binary.
wget --no-verbose https://download.jetbrains.com/idea/${idea_binary}

# verify the downloaded binary.
echo "${idea_sha256} ${idea_binary}" | sha256sum --check
# ideaIC-${idea_release}-no-jbr.tar.gz: OK

# extract intellij idea community edition binary.
rm -f ${idea_home}
tar -zxvf ${idea_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${idea_folder}
ln -s ${idea_folder} ${idea_home}
rm -f ${idea_binary}

# install intellij idea community edition as gnome desktop app. ------------------------------------
imgname="intellij-idea-logo"
imgsizearray=( "16x16" "22x22" "24x24" "32x32" "48x48" "64x64" "128x128" "256x256" )
imgfolder="/usr/share/icons/hicolor"

cd ${devops_home}/provisioners/scripts/centos

# install intellij idea community edition icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}-${imgsize}.png..."
    install -o root -g root -m 0644 ./images/${imgname}-${imgsize}.png ${imgfolder}/${imgsize}/apps/${imgname}.png
  fi
done

# install intellij idea community edition desktop in applications menu. ----------------------------
echo "Installing intellij-idea-community.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/intellij-idea-community.desktop
update-desktop-database /usr/share/applications/

# copy intellij idea community edition launcher to devops applications folder. -
echo "Copying intellij-idea-community.desktop launcher to devops 'applications' folder..."
mkdir -p ${devops_home}/provisioners/scripts/centos/applications
cd ${devops_home}/provisioners/scripts/centos/applications
cp -f /usr/share/applications/intellij-idea-community.desktop .
chmod 755 ./intellij-idea-community.desktop
