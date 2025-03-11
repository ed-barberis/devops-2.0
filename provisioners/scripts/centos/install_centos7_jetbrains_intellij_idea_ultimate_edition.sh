#!/bin/sh -eux
# install intellij idea ultimate edition by jetbrains.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install intellij idea ultimate edition. ----------------------------------------------------------
idea_home="idea-IU"
idea_release="2024.3.4.1"
idea_build="243.25659.59"
idea_folder="idea-IU-${idea_build}"

# set the idea binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  idea_binary="ideaIU-${idea_release}.tar.gz"
  idea_sha256="e9b5b868e425aa1255d75f85028e7ba6275bb8aab88781e960c2c7c34f2173e8"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  idea_binary="ideaIU-${idea_release}-aarch64.tar.gz"
  idea_sha256="a6245e6e1bef3062be5b06cf61bd2eb489e64c6c26f86040cb9c28e4c65e780b"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create jetbrains home parent folder.
mkdir -p /usr/local/jetbrains
cd /usr/local/jetbrains

# download intellij idea ultimate edition binary.
wget --no-verbose https://download.jetbrains.com/idea/${idea_binary}

# verify the downloaded binary.
echo "${idea_sha256} ${idea_binary}" | sha256sum --check
# ideaIU-${idea_release}-no-jbr.tar.gz: OK

# extract intellij idea ultimate edition binary.
rm -f ${idea_home}
tar -zxvf ${idea_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${idea_folder}
ln -s ${idea_folder} ${idea_home}
rm -f ${idea_binary}

# install intellij idea ultimate edition as gnome desktop app. -------------------------------------
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

# install intellij idea ultimate edition desktop in applications menu. -----------------------------
echo "Installing intellij-idea-ultimate.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/intellij-idea-ultimate.desktop
update-desktop-database /usr/share/applications/

# copy intellij idea ultimate edition launcher to devops applications folder. --
echo "Copying intellij-idea-ultimate.desktop launcher to devops 'applications' folder..."
mkdir -p ${devops_home}/provisioners/scripts/centos/applications
cd ${devops_home}/provisioners/scripts/centos/applications
cp -f /usr/share/applications/intellij-idea-ultimate.desktop .
chmod 755 ./intellij-idea-ultimate.desktop
