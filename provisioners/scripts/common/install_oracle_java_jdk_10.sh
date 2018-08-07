#!/bin/sh -eux
# install java se 10 development kit by oracle.

# install java se 10 development kit. ------------------------------------------
jdkhome="jdk10"
jdkbuild="10.0.2+13"
jdkhash="19aef61b38124481863b1413dce1855f"
jdkfolder="jdk-10.0.2"
jdkbinary="${jdkfolder}_linux-x64_bin.tar.gz"

# create java home parent folder.
mkdir -p /usr/local/java
cd /usr/local/java

# download jdk 10 binary from oracle otn.
wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${jdkbuild}/${jdkhash}/${jdkbinary}

# extract jdk 10 binary and create softlink to 'jdk10'.
rm -f ${jdkhome}
tar -zxvf ${jdkbinary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${jdkfolder}
ln -s ${jdkfolder} ${jdkhome}
rm -f ${jdkbinary}

# set jdk 10 home environment variables.
JAVA_HOME=/usr/local/java/${jdkhome}
export JAVA_HOME
PATH=${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
java -version
