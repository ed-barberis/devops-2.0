#!/bin/sh -eux
# install gradle build tool by gradle.org.

# install gradle. --------------------------------------------------------------
# create gradle parent folder.
mkdir -p /usr/local/gradle
cd /usr/local/gradle

# retrieve version number of latest release.
curl --silent https://docs.gradle.org/current/release-notes.html --output gradle-release-notes.html
gradlerelease=$(awk '/Release Notes<\/title>/ {print $2}' gradle-release-notes.html)
gradlefolder="gradle-${gradlerelease}"
gradlebinary="gradle-${gradlerelease}-all.zip"

# download gradle build tool from gradle.org.
curl --silent --location https://services.gradle.org/distributions/${gradlebinary} --output ${gradlebinary}

# extract gradle binary.
unzip ${gradlebinary}
chown -R root:root ./${gradlefolder}
ln -s ${gradlefolder} gradle
rm -f ${gradlebinary}

# set jdk home environment variables.
JAVA_HOME=/usr/local/java/jdk180
export JAVA_HOME

# set gradle environment variables.
GRADLE_HOME=/usr/local/gradle/gradle
export GRADLE_HOME
PATH=${GRADLE_HOME}/bin:${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
gradle --version
