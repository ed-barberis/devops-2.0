#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install Java SE 25 Development Kit by Oracle.
#
# The Java Platform, Standard Edition Development Kit (JDK) 25 is a development environment for
# building applications and components using the Java programming language.
#
# The JDK includes tools useful for developing, testing, and monitoring programs written in the
# Java programming language and running on the Java platform.
#
# For more details, please visit:
#   https://docs.oracle.com/en/java/javase/25/
#   https://www.oracle.com/java/technologies/javase/jdk25-readme-downloads.html
#   https://www.oracle.com/java/technologies/downloads/#java25
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install java se 25 development kit. --------------------------------------------------------------
jdk_home="jdk25"
jdk_build="25.0.0"
jdk_folder="jdk-${jdk_build:0:2}"

# set the jdk sha256 and arch values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  jdk_sha256="7a69dcae4842aedbec9bee0e1b0df441528ac8c8e21fe884d3b849262ae28c02"
  jdk_arch="x64"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  jdk_sha256="45c85c377afc1d26a41cdc4590e5905c7639b36084f3562f534f27a8eb0f9361"
  jdk_arch="aarch64"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

jdk_binary="${jdk_folder}_linux-${jdk_arch}_bin.tar.gz"

# create java home parent folder.
mkdir -p /usr/local/java
cd /usr/local/java

# download jdk 25 binary from oracle otn.
wget --no-verbose https://download.oracle.com/java/${jdk_build:0:2}/archive/${jdk_binary}
#wget --no-verbose https://download.oracle.com/java/${jdk_build:0:2}/latest/${jdk_binary}   # permanent (latest) url.

# verify the downloaded binary.
echo "${jdk_sha256} ${jdk_binary}" | sha256sum --check
# ${jdk_folder}_linux-${jdk_arch}_bin.tar.gz: OK

# extract jdk 25 binary and create softlink to 'jdk25'.
rm -f ${jdk_home}
rm -rf ${jdk_folder}
tar -zxvf ${jdk_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${jdk_folder}
ln -s ${jdk_folder} ${jdk_home}
rm -f ${jdk_binary}

# set jdk 25 home environment variables.
JAVA_HOME=/usr/local/java/${jdk_home}
export JAVA_HOME
PATH=${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
java --version
