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
curl --silent --dump-header curl-${sbthome}.${curdate}.out https://github.com/sbt/sbt/releases/latest --output /dev/null
sbt_release=$(awk '{ sub("\r$", ""); print }' curl-${sbthome}.${curdate}.out | awk '/Location/ {print $2}' | awk -F "/" '{print $8}')
sbt_release="v1.6.2"
sbt_dir="sbt"
sbt_folder="${sbthome}-${sbt_release:1}"
sbt_binary="sbt-${sbt_release:1}.tgz"
sbt_sha256="637637b6c4e6fa04ab62cd364061e32b12480b09001cd23303df62b36fadd440"

rm -f curl-${sbthome}.${curdate}.out

# download sbt from cocl.us.
wget --no-verbose https://github.com/sbt/sbt/releases/download/${sbt_release}/${sbt_binary}

# verify the downloaded binary.
echo "${sbt_sha256} ${sbt_binary}" | sha256sum --check
# sbt-${sbt_release:1}.tgz: OK

# extract sbt binary.
rm -f ${sbthome}
tar -zxvf ${sbt_binary} --no-same-owner --no-overwrite-dir
mv -f ${sbt_dir} ${sbt_folder}
chown -R root:root ./${sbt_folder}
ln -s ${sbt_folder} ${sbthome}
rm -f ${sbt_binary}

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
