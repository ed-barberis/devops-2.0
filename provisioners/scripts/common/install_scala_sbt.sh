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
sbt_release="v1.9.1"
sbt_dir="sbt"
sbt_folder="${sbthome}-${sbt_release:1}"
sbt_binary="sbt-${sbt_release:1}.tgz"
sbt_sha256="29cca5153cc96315d6e423777e5800b831e45723b47732c207a66efa5ca4fc2b"

rm -f curl-${sbthome}.${curdate}.out

# download sbt from cocl.us.
wget --no-verbose https://github.com/sbt/sbt/releases/download/${sbt_release}/${sbt_binary}

# verify the downloaded binary.
echo "${sbt_sha256} ${sbt_binary}" | sha256sum --check
# sbt-${sbt_release:1}.tgz: OK

# extract sbt binary.
rm -f ${sbthome}
rm -Rf ${sbt_folder}
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
# NOTE: sbt 1.7.0 introduced an out of memory issue when '-Xms' heap size is set or the default is used.
#       expliciting setting 'SBT_OPTS' to exclude it solved the problem.
SBT_OPTS="-Xmx1024m -Xss4M -XX:ReservedCodeCacheSize=128m"
export SBT_OPTS
SBT_HOME=/usr/local/scala/${sbthome}
export SBT_HOME
PATH=${SBT_HOME}/bin:${SCALA_HOME}/bin:${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
sbt about
#sbt sbtVersion

# sbt quick-start examples. ------------------------------------------------------------------------
# 1. Create a minimum 'sbt' build to use Scala 3.1.3.
#
#    $ mkdir -p foo-build
#    $ cd foo-build
#    $ touch build.sbt
#    $ echo "ThisBuild / scalaVersion := "3.1.3" >> build.sbt
#
# 2. Set 'sbt' environment variables.
#
#    $ export SBT_OPTS="-Xmx1024m -Xss4M -XX:ReservedCodeCacheSize=128m"
#    $ export SBT_HOME=/usr/local/scala/scala-sbt
#    $ export PATH=$SBT_HOME/bin:$PATH
#
# 3. Create a source file.
#
#    $ mkdir -p src/main/scala/example
#    $ vi Hello.scala
#    package example
#
#    object Hello {
#      def main(args: Array[String]): Unit = {
#        println("Hello, SBT world!")
#      }
#    }
#
# 4. Start 'sbt' shell.
#
#    $ sbt
#    [info] welcome to sbt 1.7.0 (Amazon.com Inc. Java 1.8.0_332)
#    [info] loading project definition from /home/ec2-user/projects/foo-build/project
#    [info] loading settings for project foo-build from build.sbt ...
#    [info] set current project to foo-build (in build file:/home/ec2-user/projects/foo-build/)
#    [info]
#    [info] Here are some highlights of this release:
#    [info]   - `++ <sv> <command1>` updates
#    [info]   - Scala 3 compiler error improvements
#    [info]   - Improved Build Server Protocol (BSP) support
#    [info] See https://eed3si9n.com/sbt-1.7.0 for full release notes.
#    [info] Hide the banner for this release by running `skipBanner`.
#    [info] sbt server started at local:///home/ec2-user/.sbt/1.0/server/860c0c6b957e82513158/sock
#    [info] started sbt server
#    sbt:foo-build>
#
# 5. Compile a project.
#
#    sbt:foo-build> compile
#    [success] Total time: 3 s, completed Jul 11, 2022 5:49:42 PM
#
# 6. Run your application.
#
#    sbt:foo-build> run
#    [info] running example.Hello
#    Hello, SBT world!
#    [success] Total time: 1 s, completed Jul 11, 2022 5:50:41 PM
