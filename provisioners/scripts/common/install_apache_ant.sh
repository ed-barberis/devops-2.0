#!/bin/sh -eux
# install ant build tool by apache.

# set default value for devops home environment variable if not set. -------------------------------
#devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# install apache ant. ------------------------------------------------------------------------------
ant_home="apache-ant"
ant_release="1.10.15"
ant_folder="${ant_home}-${ant_release}"
ant_binary="${ant_folder}-bin.tar.gz"
ant_sha512="d78427aff207592c024ff1552dc04f7b57065a195c42d398fcffe7a0145e8d00cd46786f5aa52e77ab0fdf81334f065eb8011eecd2b48f7228e97ff4cb20d16c"

# create apache parent folder.
mkdir -p /usr/local/apache
cd /usr/local/apache

# download ant binary from apache.org.
wget --no-verbose http://archive.apache.org/dist/ant/binaries/${ant_binary}

# verify the downloaded binary.
echo "${ant_sha512} ${ant_binary}" | sha512sum --check
# ${ant_folder}-bin.tar.gz: OK

# extract ant binary.
rm -f ${ant_home}
tar -zxvf ${ant_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${ant_folder}
ln -s ${ant_folder} ${ant_home}
rm -f ${ant_binary}

# set jdk home environment variables.
JAVA_HOME=/usr/local/java/jdk180
export JAVA_HOME

# set ant home environment variables.
ANT_HOME=/usr/local/apache/${ant_home}
export ANT_HOME
PATH=${ANT_HOME}/bin:${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
ant -version

# install apache ant contrib. ----------------------------------------------------------------------
ant_contrib_folder="ant-contrib"
ant_contrib_release="1.0b3"
ant_contrib_binary="${ant_contrib_folder}-${ant_contrib_release}-bin.tar.gz"
ant_contrib_jar="${ant_contrib_folder}-${ant_contrib_release}.jar"

# create apache contrib parent folder.
mkdir -p /usr/local/apache
cd /usr/local/apache

# download ant contrib library from sourceforge.net.
curl --silent --location "https://sourceforge.net/projects/${ant_contrib_folder}/files/${ant_contrib_folder}/${ant_contrib_release}/${ant_contrib_binary}/download" --output ${ant_contrib_binary}
#cp -f ${devops_home}/provisioners/scripts/common/tools/${ant_contrib_binary} .

# extract ant contrib binary.
tar -zxvf ${ant_contrib_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${ant_contrib_folder}
rm -f ${ant_contrib_binary}

# copy ant contrib library to apache-ant/lib.
cd /usr/local/apache/${ant_contrib_folder}
cp -p ${ant_contrib_jar} /usr/local/apache/${ant_home}/lib
