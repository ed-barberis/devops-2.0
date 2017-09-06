#!/bin/sh -eux
# install scala build tool (sbt) for scala.

# install sbt. -----------------------------------------------------------------
sbthome="scala-sbt"

# create scala parent folder.
mkdir -p /usr/local/scala
cd /usr/local/scala

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d")

# retrieve version number of latest release.
curl --silent --dump-header curl-${sbthome}.${curdate}.out1 https://github.com/sbt/sbt/releases/latest --output /dev/null
tr -d '\r' < curl-${sbthome}.${curdate}.out1 > curl-${sbthome}.${curdate}.out2
sbtrelease=$(awk '/Location/ {print $2}' curl-${sbthome}.${curdate}.out2 | awk -F "/" '{print $8}')
sbtdir="sbt"
sbtfolder="${sbthome}-${sbtrelease:1}"
sbtbinary="sbt-${sbtrelease:1}.tgz"
rm -f curl-${sbthome}.${curdate}.out1
rm -f curl-${sbthome}.${curdate}.out2

# download sbt from cocl.us.
wget --no-verbose https://cocl.us/${sbtbinary}

# extract sbt binary.
tar -zxvf ${sbtbinary} --no-same-owner --no-overwrite-dir
mv -f ${sbtdir} ${sbtfolder}
chown -R root:root ./${sbtfolder}
ln -s ${sbtfolder} ${sbthome}
rm -f ${sbtbinary}

# set jdk home environment variables.
JAVA_HOME=/usr/local/java/jdk180
export JAVA_HOME

# set scala home environment variables.
SCALA_HOME=/usr/local/scala/scala-lang
export SCALA_HOME

# set sbt home environment variables.
SBT_HOME=/usr/local/scala/${sbthome}
export SBT_HOME
PATH=${SBT_HOME}/bin:${SCALA_HOME}/bin:${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
sbt about
#sbt sbtVersion

# configure scala-sbt user environment variables. ------------------------------
# add environment variables to '.bashrc' for user 'vagrant'.
sbt_env_comment="${sbthome}"
sbt_env_name="SBT_HOME"
sbt_env_value="/usr/local/scala/${sbthome}"

cd /home/vagrant
awk -v env_comment=${sbt_env_comment} -v env_name=${sbt_env_name} -v env_value=${sbt_env_value} -f /tmp/scripts/oracle/append_ol7_env_path.awk .bashrc > .bashrc.${curdate}.${sbthome}
mv -f .bashrc.${curdate}.${sbthome} .bashrc

chown vagrant:vagrant .bashrc
chmod 644 .bashrc
