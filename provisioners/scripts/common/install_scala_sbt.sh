#!/bin/sh -eux
# install scala build tool (sbt) for scala.

# install sbt. -------------------------------------------------------------------------------------
sbthome="scala-sbt"

# create scala parent folder.
mkdir -p /usr/local/scala
cd /usr/local/scala

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# retrieve version number of latest release.
curl --silent --dump-header curl-${sbthome}.${curdate}.out1 https://github.com/sbt/sbt/releases/latest --output /dev/null
tr -d '\r' < curl-${sbthome}.${curdate}.out1 > curl-${sbthome}.${curdate}.out2
sbtrelease=$(awk '/Location/ {print $2}' curl-${sbthome}.${curdate}.out2 | awk -F "/" '{print $8}')
sbtrelease="v1.3.7"
sbtdir="sbt"
sbtfolder="${sbthome}-${sbtrelease:1}"
sbtbinary="sbt-${sbtrelease:1}.tgz"
rm -f curl-${sbthome}.${curdate}.out1
rm -f curl-${sbthome}.${curdate}.out2

# download sbt from cocl.us.
wget --no-verbose https://github.com/sbt/sbt/releases/download/${sbtrelease}/${sbtbinary}

# extract sbt binary.
rm -f ${sbthome}
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
