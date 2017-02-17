#!/bin/sh -eux
# install useful gui developer tools.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# install the adobe flash plug-in. ---------------------------------------------
wget --no-verbose http://linuxdownload.adobe.com/linux/x86_64/adobe-release-x86_64-1.0-1.noarch.rpm
yum repolist
yum -y install adobe-release-x86_64-1.0-1.noarch.rpm
yum -y install flash-plugin

# install linux chrome browser. ------------------------------------------------
wget --no-verbose https://chrome.richardlloyd.org.uk/install_chrome.sh
chmod 755 install_chrome.sh
./install_chrome.sh -f

# install linux chrome launcher on user desktop.
#echo "Installing google-chrome.desktop on user desktop..."
#mkdir -p /home/vagrant/Desktop
#cd /home/vagrant/Desktop
#cp -f /usr/share/applications/google-chrome.desktop .

#chown -R vagrant:vagrant .
#chmod 755 ./google-chrome.desktop

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

# install postman as gnome desktop app.
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

# install postman desktop in applications menu.
echo "Installing postman.desktop in applications menu..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/postman.desktop
update-desktop-database /usr/share/applications/

# install postman launcher on user desktop.
echo "Installing postman.desktop on user desktop..."
mkdir -p /home/vagrant/Desktop
cd /home/vagrant/Desktop
cp -f /usr/share/applications/postman.desktop .

chown -R vagrant:vagrant .
chmod 755 ./postman.desktop

# install 'gvim' graphical editor. ---------------------------------------------
yum -y install vim-X11
gvim --version

# install useful system configuration edit tools. ------------------------------
yum -y install alacarte
yum -y install dconf-editor
yum -y install gnome-shell-browser-plugin
