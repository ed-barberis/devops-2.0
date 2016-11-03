#!/bin/sh -eux
# install useful developer tools.

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

# install software collections library. (needed later for python 3.x.) ---------
yum -y install scl-utils

# install git. -----------------------------------------------------------------
cd /tmp/scripts/oracle
yum -y install git
git --version

# install 'gvim' graphical editor. ---------------------------------------------
yum -y install vim-X11
gvim --version

# install useful system configuration edit tools. ------------------------------
yum -y install alacarte
yum -y install dconf-editor
yum -y install gnome-shell-browser-plugin

# install oracle java se development kit 8u111. --------------------------------
jdkbuild="8u111-b14"
jdkbinary="jdk-8u111-linux-x64.tar.gz"
jdkfolder="jdk1.8.0_111"

# create java home parent folder.
mkdir -p /usr/local/java
cd /usr/local/java

# download jdk binary from oracle otn.
wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${jdkbuild}/${jdkbinary}
#wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip

# extract jdk binary and create softlink to 'jdk180'.
tar -zxvf ${jdkbinary}
chown -R root:root ./${jdkfolder}
ln -s ${jdkfolder} jdk180
rm -f ${jdkbinary}

# set jdk home environment variables.
JAVA_HOME=/usr/local/java/jdk180
export JAVA_HOME
PATH=${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
java -version

# install apache ant 1.9.7. ----------------------------------------------------
antbinary="apache-ant-1.9.7-bin.tar.gz"
antfolder="apache-ant-1.9.7"
#antbinary="apache-ant-1.9.2-bin.tar.gz"
#antfolder="apache-ant-1.9.2"

# create apache parent folder.
mkdir -p /usr/local/apache
cd /usr/local/apache

# download ant binary from apache.org.
wget --no-verbose http://archive.apache.org/dist/ant/binaries/${antbinary}

# extract ant binary.
tar -zxvf ${antbinary}
chown -R root:root ./${antfolder}
rm -f ${antbinary}

# set ant home environment variables.
ANT_HOME=/usr/local/apache/${antfolder}
export ANT_HOME
PATH=${ANT_HOME}/bin:$PATH
export PATH

# verify installation.
ant -version

# install apache maven 3.3.9. --------------------------------------------------
mvnrelease="3.3.9"
mvnbinary="apache-maven-3.3.9-bin.tar.gz"
mvnfolder="apache-maven-3.3.9"
#mvnrelease="3.2.5"
#mvnbinary="apache-maven-3.2.5-bin.tar.gz"
#mvnfolder="apache-maven-3.2.5"

# create apache parent folder.
mkdir -p /usr/local/apache
cd /usr/local/apache

# download maven binary from apache.org.
wget --no-verbose http://archive.apache.org/dist/maven/maven-3/${mvnrelease}/binaries/${mvnbinary}

# extract maven binary.
tar -zxvf ${mvnbinary}
chown -R root:root ./${mvnfolder}
rm -f ${mvnbinary}

# set maven home environment variables.
M2_HOME=/usr/local/apache/${mvnfolder}
export M2_HOME
M2_REPO=$HOME/.m2
export M2_REPO
MAVEN_OPTS=-Dfile.encoding="UTF-8"
export MAVEN_OPTS
M2=$M2_HOME/bin
export M2
PATH=${M2}:$PATH
export PATH

# verify installation.
mvn --version
