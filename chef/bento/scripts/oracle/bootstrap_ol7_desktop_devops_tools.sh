#!/bin/sh -eux
# install useful gui developer tools.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# install the adobe flash plug-in. ---------------------------------------------
wget --no-verbose http://linuxdownload.adobe.com/linux/x86_64/adobe-release-x86_64-1.0-1.noarch.rpm
rpm -Uvh adobe-release-x86_64-1.0-1.noarch.rpm
yum repolist
yum -y install flash-plugin

# install linux chrome browser. ------------------------------------------------
wget --no-verbose https://chrome.richardlloyd.org.uk/install_chrome.sh
chmod 755 install_chrome.sh
./install_chrome.sh -f

# install postman rest client. -------------------------------------------------
postmanbinary="Postman-linux-x64.tar.gz"
postmanfolder="Postman"

# create postman home parent folder.
mkdir -p /usr/local/google
cd /usr/local/google

# download postman binary.
curl --silent https://dl.pstmn.io/download/latest/linux?arch=64 --output ${postmanbinary}

# extract postman binary.
tar -zxvf ${postmanbinary}
chown -R root:root ./${postmanfolder}
rm -f ${postmanbinary}

# set postman home environment variables.
#POSTMAN_HOME=/usr/local/google/${postmanfolder}
#export POSTMAN_HOME
#PATH=${POSTMAN_HOME}:$PATH
#export PATH

# verify installation.  (currently not available.)
#Postman --version

cd /tmp/scripts/oracle

# install postman as gnome desktop app.
imgname="postman-logo"
imgsizearray=( "16x16" "22x22" "24x24" "32x32" "48x48" "64x64" "128x128" "256x256" )
imgfolder="/usr/share/icons/hicolor"

# install postman icon image files.
for imgsize in "${imgsizearray[@]}"; do
  if [ -d "${imgfolder}/${imgsize}/apps" ]; then
    echo "Processing ${imgname}-${imgsize}.png..."
    install -o root -g root -m 0644 ./images/${imgname}-${imgsize}.png ${imgfolder}/${imgsize}/apps/${imgname}.png
  fi
done

# install postman desktop.
echo "Installing postman.desktop..."
desktop-file-install --dir=/usr/share/applications/ ./desktops/postman.desktop
update-desktop-database /usr/share/applications/

# install 'gvim' graphical editor. ---------------------------------------------
yum -y install vim-X11
gvim --version

# install useful system configuration edit tools. ------------------------------
yum -y install alacarte
yum -y install dconf-editor
yum -y install gnome-shell-browser-plugin
