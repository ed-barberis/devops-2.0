#!/bin/sh -eux
# install scala programming language.

# install scala-lang. ------------------------------------------------------------------------------
scalahome="scala-lang"

# create scala parent folder.
mkdir -p /usr/local/scala
cd /usr/local/scala

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# retrieve version number of latest release.
curl --silent --dump-header curl-${scalahome}.${curdate}.out1 https://github.com/scala/scala/releases/latest --output /dev/null
tr -d '\r' < curl-${scalahome}.${curdate}.out1 > curl-${scalahome}.${curdate}.out2
scalarelease=$(awk '/Location/ {print $2}' curl-${scalahome}.${curdate}.out2 | awk -F "/" '{print $8}')
scalarelease="v2.13.1"
scaladir="scala-${scalarelease:1}"
scalafolder="${scalahome}-${scalarelease:1}"
scalabinary="scala-${scalarelease:1}.tgz"
rm -f curl-${scalahome}.${curdate}.out1
rm -f curl-${scalahome}.${curdate}.out2

# download scala-lang from lightbend.com.
wget --no-verbose https://downloads.lightbend.com/scala/${scalarelease:1}/${scalabinary}

# extract scala-lang binary.
rm -f ${scalahome}
tar -zxvf ${scalabinary} --no-same-owner --no-overwrite-dir
mv -f ${scaladir} ${scalafolder}
chown -R root:root ./${scalafolder}
ln -s ${scalafolder} ${scalahome}
rm -f ${scalabinary}

# set jdk home environment variables.
JAVA_HOME=/usr/local/java/jdk180
export JAVA_HOME

# set scala home environment variables.
SCALA_HOME=/usr/local/scala/${scalahome}
export SCALA_HOME
PATH=${SCALA_HOME}/bin:${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
scala -version
