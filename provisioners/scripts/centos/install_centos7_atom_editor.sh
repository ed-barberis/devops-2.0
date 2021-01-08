#!/bin/sh -eux
# install atom text editor by github.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# install atom editor. -----------------------------------------------------------------------------
atomrepo="atom.x86_64.rpm"

# create scripts directory (if needed).
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# retrieve version number of latest release.
curl --silent --dump-header curl-atom.${curdate}.out https://github.com/atom/atom/releases/latest --output /dev/null
atomrelease=$(awk '{ sub("\r$", ""); print }' curl-atom.${curdate}.out | awk '/Location/ {print $2}' | awk -F "/" '{print $8}')
atomrelease="v1.53.0"
rm -f curl-atom.${curdate}.out

# download atom repository from github.com.
rm -f ${atomrepo}
wget --no-verbose https://github.com/atom/atom/releases/download/${atomrelease}/${atomrepo}
yum -y install ${atomrepo}

# verify installation.
#atom --version
#runuser -c "atom --version" - vagrant

# install atom markdown plugins.
#runuser -c "apm install tool-bar" - vagrant
#runuser -c "apm install markdown-writer" - vagrant
#runuser -c "apm install tool-bar-markdown-writer" - vagrant
#runuser -c "apm install markdown-scroll-sync" - vagrant
#runuser -c "apm install markdown-format" - vagrant

# install atom ide plugins.
#runuser -c "apm install atom-ide-ui" - vagrant
#runuser -c "apm install ide-java" - vagrant
#runuser -c "apm install ide-typescript" - vagrant

# copy atom launcher to devops applications folder. ------------------------------------------------
echo "Copying atom.desktop launcher to devops 'applications' folder..."
mkdir -p ${devops_home}/provisioners/scripts/centos/applications
cd ${devops_home}/provisioners/scripts/centos/applications
cp -f /usr/share/applications/atom.desktop .
chmod 755 ./atom.desktop
