#!/bin/sh -eux
# install scala 3 programming language.

# install scala3-lang. -----------------------------------------------------------------------------
scala3_home="scala-lang"
#scala3_release="3.3.3"                                                              # scala 3.3.3 lts release.
scala3_release="3.5.0"
scala3_dir="scala3-${scala3_release}"
scala3_folder="${scala3_home}-${scala3_release}"
scala3_binary="scala3-${scala3_release}.tar.gz"
#scala3_sha256="eb594011312faa412aaf9a5b0e5b45921f90be9f849c20e295737d5faecd14d1"    # scala 3.3.3 lts release.
scala3_sha256="bacad178623f1940dae7d75c54c75aaf53f14f07ae99803be730a1d7d51a612d"

# create scala 3 parent folder.
mkdir -p /usr/local/scala
cd /usr/local/scala

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# download scala-lang from github.com.
wget --no-verbose https://github.com/lampepfl/dotty/releases/download/${scala3_release}/${scala3_binary}

# verify the downloaded binary.
echo "${scala3_sha256} ${scala3_binary}" | sha256sum --check
# scala3-${scala3_release}.tar.gz: OK

# extract scala-lang binary.
rm -f ${scala3_home}
tar -zxvf ${scala3_binary} --no-same-owner --no-overwrite-dir
mv -f ${scala3_dir} ${scala3_folder}
chown -R root:root ./${scala3_folder}
ln -s ${scala3_folder} ${scala3_home}
rm -f ${scala3_binary}

# set jdk home environment variables.
JAVA_HOME=/usr/local/java/jdk180
export JAVA_HOME

# set scala home environment variables.
SCALA_HOME=/usr/local/scala/${scala3_home}
export SCALA_HOME
PATH=${SCALA_HOME}/bin:${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
scala -version
