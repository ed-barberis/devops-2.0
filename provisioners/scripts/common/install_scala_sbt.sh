#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install Scala Build Tool (sbt) for scala.
#
# sbt is a build tool for Scala, Java, and more. It is the build tool of choice for 84.7% of the
# Scala developers (2023). One of the examples of Scala-specific feature is the ability to cross
# build your project against multiple Scala versions. sbt requires Java 1.8 or later.
#
# Features of sbt:
# - Little or no configuration required for simple projects.
# - Scala-based build definition that can use the full flexibility of Scala code.
# - Accurate incremental recompilation using information extracted from the compiler.
# - Library management support using Coursier.
# - Continuous compilation and testing with triggered execution.
# - Supports mixed Scala/Java projects.
# - Supports testing with ScalaCheck, specs, and ScalaTest. JUnit is supported by a plugin.
# - Starts the Scala REPL with project classes and dependencies on the classpath.
# - Modularization supported with sub-projects.
# - External project support (list a git repository as a dependency!).
# - Parallel task execution, including parallel test execution.
#
# For more details, please visit:
#   https://www.scala-sbt.org/
#   https://www.scala-sbt.org/download/
#   https://www.scala-sbt.org/1.x/docs/
#   https://github.com/sbt/sbt/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# install sbt. -------------------------------------------------------------------------------------
sbt_home="scala-sbt"
sbt_release="v2.0.4"
sbt_dir="sbt"
sbt_folder="${sbt_home}-${sbt_release:1}"
sbt_binary="sbt-${sbt_release:1}.tgz"
sbt_sha256="13253ee7a8b19f60f8c6dc100249619df19ed8869f8be783ab8d206aedfdc366"

# create scala parent folder.
mkdir -p /usr/local/scala
cd /usr/local/scala

# download sbt from github.com.
rm -f ${sbt_binary}
wget --no-verbose https://github.com/sbt/sbt/releases/download/${sbt_release}/${sbt_binary}

# verify the downloaded binary.
echo "${sbt_sha256} ${sbt_binary}" | sha256sum --check
# sbt-${sbt_release:1}.tgz: OK

# extract sbt binary.
rm -f ${sbt_home}
rm -Rf ${sbt_folder}
tar -zxvf ${sbt_binary} --no-same-owner --no-overwrite-dir
mv -f ${sbt_dir} ${sbt_folder}
chown -R root:root ./${sbt_folder}
ln -s ${sbt_folder} ${sbt_home}
rm -f ${sbt_binary}

# verify installation. -----------------------------------------------------------------------------
# set jdk home environment variables.
JAVA_HOME=/usr/local/java/jdk17
export JAVA_HOME

# set scala home environment variables.
SCALA_HOME=/usr/local/scala/scala-lang
export SCALA_HOME

# set sbt home environment variables.
# NOTE: sbt 1.7.0 introduced an out of memory issue when '-Xms' heap size is set or the default is used.
#       expliciting setting 'SBT_OPTS' to exclude it solved the problem.
SBT_OPTS="-Xmx1024m -Xss4m -XX:ReservedCodeCacheSize=128m"
export SBT_OPTS
SBT_HOME=/usr/local/scala/${sbt_home}
export SBT_HOME
PATH=${SBT_HOME}/bin:${SCALA_HOME}/bin:${JAVA_HOME}/bin:$PATH
export PATH

# verify the sbt runner version.
sbt --script-version

# delete temporary sbt files.
rm -Rf /tmp/.sbt*

# sbt quick-start example. -------------------------------------------------------------------------
# 1. Create a minimum SBT build to use Scala 3.8.4.
#
#    $ mkdir -p sbt/hello-world
#    $ cd sbt/hello-world
#    $ touch build.sbt
#    $ echo "ThisBuild / scalaVersion := \"3.8.4\"" >> build.sbt
#
# 2. Set SBT environment variables.
#
#    $ export JAVA_HOME=/usr/local/java/jdk17
#    $ export SCALA_HOME=/usr/local/scala/scala-lang
#    $ export SBT_OPTS="-Xmx1024m -Xss4m -XX:ReservedCodeCacheSize=128m"
#    $ export SBT_HOME=/usr/local/scala/scala-sbt
#    $ export PATH=${SBT_HOME}/bin:${SCALA_HOME}/bin:${JAVA_HOME}/bin:$PATH
#
# 3. Create a source file.
#
#    $ mkdir -p src/main/scala/example
#    $ vi src/main/scala/example/Hello.scala
#    package example
#
#    object Hello {
#      def main(args: Array[String]): Unit = {
#        println("Hello, SBT world!")
#      }
#    }
#
# 4. Start SBT shell.
#
#    $ sbt
#    [info] server was not detected. starting an instance
#    [info] Updated file /home/vagrant/sbt/hello-world/project/build.properties: set sbt.version to 2.0.1
#    [info] welcome to sbt 2.0.1 (Amazon.com Inc. Java 17.0.19)
#    [info] loading project definition from /home/vagrant/sbt/hello-world/project
#    [info] set current project to hello-world (in build file:/home/vagrant/sbt/hello-world/)
#    [info]
#    [info] Here are some highlights of sbt 2.0.1:
#    [info]   - Scala 3 in metabuild
#    [info]   - Common settings
#    [info]   - test changed to incremental test
#    [info]   - Cache system
#    [info] See https://www.scala-sbt.org/2.x/docs/en/changes/sbt-2.0-change-summary.html
#    [info] Hide the banner for this release by running `skipBanner`.
#    [info] sbt server started at local:///home/vagrant/.config/sbt/2/server/7f8775e321749d739d56/sock
#    [info] started sbt server
#    [info] terminate the server with `shutdown`
#
# 5. Compile a project.
#
#    sbt:hello-world> compile
#    [info] compiling 1 Scala source to /home/vagrant/sbt/hello-world/target/out/jvm/scala-3.8.4/hello-world/classes ...
#    [success] elapsed time: 2 s, cache 66%, 8 disk cache hits, 4 onsite tasks
#
# 6. Run your application.
#
#    sbt:hello-world> run
#    [info] running (fork) example.Hello
#    Hello, SBT world!
#    [success] ok
#
# 7. Exit the SBT shell.
#
#    sbt:hello-world> exit
#    [info] disconnected
#
# Congratulations, you just compiled and ran your first SBT application!
