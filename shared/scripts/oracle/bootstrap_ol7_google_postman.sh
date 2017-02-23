#!/bin/sh -eux
# install postman app rest client tool by google.

# install postman app. ---------------------------------------------------------
postmanbinary="Postman-linux-x64.tar.gz"
postmanfolder="Postman"

# create postman home parent folder.
mkdir -p /usr/local/google
cd /usr/local/google

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d")

# download postman binary and retrieve version number of latest release.
curl --silent --dump-header curl-postman-linux-x64.${curdate}.out1 https://dl.pstmn.io/download/latest/linux?arch=64 --output ${postmanbinary}
tr -d '\r' < curl-postman-linux-x64.${curdate}.out1 > curl-postman-linux-x64.${curdate}.out2
postmanrelease=$(awk -F "=" '/filename/ {print $2}' curl-postman-linux-x64.${curdate}.out2)
mv ${postmanbinary} ${postmanrelease}
rm -f curl-postman-linux-x64.${curdate}.out1
rm -f curl-postman-linux-x64.${curdate}.out2

# extract postman binary.
tar -zxvf ${postmanrelease} --no-same-owner --no-overwrite-dir
chown -R root:root ./${postmanfolder}
mv ${postmanfolder} ${postmanrelease:0:-7}
ln -s ${postmanrelease:0:-7} ${postmanfolder}
rm -f ${postmanrelease}

# install postman as gnome desktop app. ----------------------------------------
imgname="postman-logo"
imgsizearray=( "16x16" "22x22" "24x24" "32x32" "48x48" "64x64" "128x128" "256x256" )
imgfolder="/usr/share/icons/hicolor"

cd /tmp/scripts/oracle

# install postman icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}-${imgsize}.png..."
    install -o root -g root -m 0644 ./images/${imgname}-${imgsize}.png ${imgfolder}/${imgsize}/apps/${imgname}.png
  fi
done

# install postman desktop in applications menu. --------------------------------
echo "Installing postman.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/postman.desktop
update-desktop-database /usr/share/applications/

# install postman launcher on user desktop. ------------------------------------
echo "Installing postman.desktop on user desktop..."
mkdir -p /home/vagrant/Desktop
cd /home/vagrant/Desktop
cp -f /usr/share/applications/postman.desktop .

chown -R vagrant:vagrant .
chmod 755 ./postman.desktop
