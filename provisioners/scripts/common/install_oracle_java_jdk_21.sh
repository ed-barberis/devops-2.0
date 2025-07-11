#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install Java SE 21 Development Kit by Oracle.
#
# The Java Platform, Standard Edition Development Kit (JDK) 21 is a development environment for
# building applications and components using the Java programming language.
#
# The JDK includes tools useful for developing, testing, and monitoring programs written in the
# Java programming language and running on the Java platform.
#
# For more details, please visit:
#   https://docs.oracle.com/en/java/javase/21/
#   https://www.oracle.com/java/technologies/javase/jdk21-readme-downloads.html
#   https://www.oracle.com/java/technologies/downloads/#java21
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install java se 21 development kit. --------------------------------------------------------------
jdk_home="jdk21"
jdk_build="21.0.7"
jdk_folder="jdk-${jdk_build}"

# set the jdk sha256 and arch values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  jdk_sha256="267b10b14b4e5fada19aca3be3b961ce4f81f1bd3ffcd070e90a5586106125eb"
  jdk_arch="x64"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  jdk_sha256="47372cfa9244dc74ec783a1b287381502419b564fbd0b18abc8f2d6b19ac865e"
  jdk_arch="aarch64"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

jdk_binary="${jdk_folder}_linux-${jdk_arch}_bin.tar.gz"

# create java home parent folder.
mkdir -p /usr/local/java
cd /usr/local/java

# download jdk 21 binary from oracle otn.
wget --no-verbose https://download.oracle.com/java/${jdk_build:0:2}/archive/${jdk_binary}
#wget --no-verbose https://download.oracle.com/java/${jdk_build:0:2}/latest/${jdk_binary}   # permanent (latest) url.

# verify the downloaded binary.
echo "${jdk_sha256} ${jdk_binary}" | sha256sum --check
# ${jdk_folder}_linux-${jdk_arch}_bin.tar.gz: OK

# extract jdk 21 binary and create softlink to 'jdk21'.
rm -f ${jdk_home}
rm -rf ${jdk_folder}
tar -zxvf ${jdk_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${jdk_folder}
ln -s ${jdk_folder} ${jdk_home}
rm -f ${jdk_binary}

# set jdk 21 home environment variables.
JAVA_HOME=/usr/local/java/${jdk_home}
export JAVA_HOME
PATH=${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
java --version
