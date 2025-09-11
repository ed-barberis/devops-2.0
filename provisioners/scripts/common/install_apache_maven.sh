#!/bin/sh -eux
# install maven build tool by apache.

# install apache maven. ----------------------------------------------------------------------------
m2home="apache-maven"
mvn_release="3.9.11"
mvn_folder="${m2home}-${mvn_release}"
mvn_binary="${mvn_folder}-bin.tar.gz"
mvn_sha512="bcfe4fe305c962ace56ac7b5fc7a08b87d5abd8b7e89027ab251069faebee516b0ded8961445d6d91ec1985dfe30f8153268843c89aa392733d1a3ec956c9978"

# create apache parent folder.
mkdir -p /usr/local/apache
cd /usr/local/apache

# download maven binary from apache.org.
wget --no-verbose https://dlcdn.apache.org/maven/maven-3/${mvn_release}/binaries/${mvn_binary}

# verify the downloaded binary.
echo "${mvn_sha512} ${mvn_binary}" | sha512sum --check
# ${mvn_folder}-bin.tar.gz: OK

# extract maven binary.
rm -f ${m2home}
tar -zxvf ${mvn_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${mvn_folder}
ln -s ${mvn_folder} ${m2home}
rm -f ${mvn_binary}

# set jdk home environment variables.
JAVA_HOME=/usr/local/java/jdk17
export JAVA_HOME

# set maven home environment variables.
M2_HOME=/usr/local/apache/${m2home}
export M2_HOME
M2_REPO=$HOME/.m2
export M2_REPO
MAVEN_OPTS=-Dfile.encoding="UTF-8"
export MAVEN_OPTS
M2=$M2_HOME/bin
export M2
PATH=${M2}:${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
mvn --version
