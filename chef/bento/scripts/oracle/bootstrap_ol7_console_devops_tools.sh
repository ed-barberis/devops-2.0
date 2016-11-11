#!/bin/sh -eux
# install useful command-line developer tools.

# install software collections library. (needed later for python 3.x.) ---------
yum -y install scl-utils

# install git. -----------------------------------------------------------------
yum -y install git
git --version

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
