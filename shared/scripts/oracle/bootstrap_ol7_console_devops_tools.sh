#!/bin/sh -eux
# install useful command-line developer tools.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# install epel repository if needed. -------------------------------------------
if [ ! -f "/etc/yum.repos.d/epel.repo" ]; then
  wget --no-verbose https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  yum repolist
  yum -y install epel-release-latest-7.noarch.rpm
fi

# update the repository list. --------------------------------------------------
yum repolist

# install python 2.x pip and setuptools. ---------------------------------------
yum -y install python-pip
python --version
pip --version

# upgrade python 2.x pip.
pip install --upgrade pip
pip --version

# install python 2.x setup tools.
yum -y install python-setuptools
#pip install --upgrade setuptools
pip install 'setuptools==33.1.1'
easy_install --version

# install software collections library. (needed later for python 3.x.) ---------
yum -y install scl-utils

# install git. -----------------------------------------------------------------
yum -y install git
git --version

# install oracle java se development kit. --------------------------------------
jdkbuild="8u121-b13"
jdkhash="e9e7ea248e2c4826b92b3f075a80e441"
jdkbinary="jdk-8u121-linux-x64.tar.gz"
jdkfolder="jdk1.8.0_121"

# create java home parent folder.
mkdir -p /usr/local/java
cd /usr/local/java

# download jdk binary from oracle otn.
wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${jdkbuild}/${jdkhash}/${jdkbinary}
#wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip

# extract jdk binary and create softlink to 'jdk180'.
tar -zxvf ${jdkbinary} --no-same-owner --no-overwrite-dir
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

# install apache ant. ----------------------------------------------------------
antfolder="apache-ant-1.10.1"
antbinary="${antfolder}-bin.tar.gz"

# create apache parent folder.
mkdir -p /usr/local/apache
cd /usr/local/apache

# download ant binary from apache.org.
wget --no-verbose http://archive.apache.org/dist/ant/binaries/${antbinary}

# extract ant binary.
tar -zxvf ${antbinary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${antfolder}
ln -s ${antfolder} apache-ant
rm -f ${antbinary}

# set ant home environment variables.
ANT_HOME=/usr/local/apache/apache-ant
export ANT_HOME
PATH=${ANT_HOME}/bin:$PATH
export PATH

# verify installation.
ant -version

# install apache ant contrib. --------------------------------------------------
acfolder="ant-contrib"
acrelease="1.0b3"
acbinary="${acfolder}-${acrelease}-bin.tar.gz"
acjar="${acfolder}-${acrelease}.jar"

# create apache contrib parent folder.
mkdir -p /usr/local/apache
cd /usr/local/apache

# download ant contrib library from sourceforge.net.
curl --silent --location "https://sourceforge.net/projects/${acfolder}/files/${acfolder}/${acrelease}/${acbinary}/download" --output ${acbinary}

# extract ant contrib binary.
tar -zxvf ${acbinary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${acfolder}
rm -f ${acbinary}

# copy ant contrib library to apache-ant/lib.
cd /usr/local/apache/${acfolder}
cp -p ${acjar} /usr/local/apache/apache-ant/lib

# install apache maven. --------------------------------------------------------
mvnrelease="3.3.9"
mvnfolder="apache-maven-${mvnrelease}"
mvnbinary="${mvnfolder}-bin.tar.gz"

# create apache parent folder.
mkdir -p /usr/local/apache
cd /usr/local/apache

# download maven binary from apache.org.
wget --no-verbose http://archive.apache.org/dist/maven/maven-3/${mvnrelease}/binaries/${mvnbinary}

# extract maven binary.
tar -zxvf ${mvnbinary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${mvnfolder}
ln -s ${mvnfolder} apache-maven
rm -f ${mvnbinary}

# set maven home environment variables.
M2_HOME=/usr/local/apache/apache-maven
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
