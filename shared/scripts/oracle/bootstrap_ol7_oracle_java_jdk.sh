#!/bin/sh -eux
# install java se development kit by oracle.

# install java se development kit. ---------------------------------------------
jdkbuild="8u131-b11"
jdkhash="d54c1d3a095b4ff2b6607d096fa80163"
jdkbinary="jdk-8u131-linux-x64.tar.gz"
jdkfolder="jdk1.8.0_131"

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
