#!/bin/sh -eux
# install webstorm javascript ide by jetbrains.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install webstorm javascript ide. -----------------------------------------------------------------
webstorm_home="webstorm"
webstorm_release="2024.3.5"
webstorm_build="243.26053.12"
webstorm_folder="WebStorm-${webstorm_build}"

# set the webstorm binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  webstorm_binary="WebStorm-${webstorm_release}.tar.gz"
  webstorm_sha256="da587d7ca3ebb08f067143e4a6b35f1aa133aa10af7fc365496838006fcd1aed"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  webstorm_binary="WebStorm-${webstorm_release}-aarch64.tar.gz"
  webstorm_sha256="fce5d5c2b8c5aacfabac60ff93b93d7c9a3239adcf8347b3deabd472ac1c1288"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create jetbrains home parent folder.
mkdir -p /usr/local/jetbrains
cd /usr/local/jetbrains

# download webstorm javascript ide binary.
wget --no-verbose https://download.jetbrains.com/webstorm/${webstorm_binary}

# verify the downloaded binary.
echo "${webstorm_sha256} ${webstorm_binary}" | sha256sum --check
# WebStorm-${webstorm_release}.tar.gz: OK
# WebStorm-${webstorm_release}-aarch64.tar.gz

# extract webstorm javascript ide binary.
rm -f ${webstorm_home}
tar -zxvf ${webstorm_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${webstorm_folder}
ln -s ${webstorm_folder} ${webstorm_home}
rm -f ${webstorm_binary}

# install webstorm javascript ide as gnome desktop app. --------------------------------------------
imgname="webstorm-logo"
imgsizearray=( "16x16" "22x22" "24x24" "32x32" "48x48" "64x64" "128x128" "256x256" )
imgfolder="/usr/share/icons/hicolor"

cd ${devops_home}/provisioners/scripts/centos

# install webstorm javascript ide icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}-${imgsize}.png..."
    install -o root -g root -m 0644 ./images/${imgname}-${imgsize}.png ${imgfolder}/${imgsize}/apps/${imgname}.png
  fi
done

# install webstorm javascript ide desktop in applications menu. ------------------------------------
echo "Installing webstorm.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/webstorm.desktop
update-desktop-database /usr/share/applications/

# copy webstorm javascript ide launcher to devops applications folder. -----------------------------
echo "Copying webstorm.desktop launcher to devops 'applications' folder..."
mkdir -p ${devops_home}/provisioners/scripts/centos/applications
cd ${devops_home}/provisioners/scripts/centos/applications
cp -f /usr/share/applications/webstorm.desktop .
chmod 755 ./webstorm.desktop
