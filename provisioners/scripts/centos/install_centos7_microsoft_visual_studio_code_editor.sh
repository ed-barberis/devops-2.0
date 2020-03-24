#!/bin/sh -eux
# install visual studio code ide by microsoft.

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# install visual studio code editor. ---------------------------------------------------------------
# create scripts directory (if needed).
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# retrieve download location and repository of latest release.
#curl --silent --dump-header curl-get-code.${curdate}.out https://go.microsoft.com/fwlink/?LinkID=620884 --output /dev/null
#curl --silent --dump-header curl-vscode.${curdate}.out https://vscode-update.azurewebsites.net/latest/linux-x64/stable --output /dev/null
#curl --silent --dump-header curl-get-code.${curdate}.out https://go.microsoft.com/fwlink/?LinkID=760867 --output /dev/null
#curl --silent --dump-header curl-vscode.${curdate}.out https://vscode-update.azurewebsites.net/latest/linux-rpm-x64/stable --output /dev/null
curl --silent --dump-header curl-vscode.${curdate}.out https://update.code.visualstudio.com/latest/linux-rpm-x64/stable --output /dev/null
vscodelocation=$(awk '{ sub("\r$", ""); print }'  curl-vscode.${curdate}.out | awk '/Location/ {print $2}')
vscoderepo=$(awk '{ sub("\r$", ""); print }'  curl-vscode.${curdate}.out | awk '/Location/ {print $2}' | awk -F "/" '{print $6}')
rm -f curl-vscode.${curdate}.out

# download visual studio code repository from microsoft.
rm -f ${vscoderepo}
wget --no-verbose ${vscodelocation}
yum -y install ${vscoderepo}

# verify installation.
#code --version

# copy visual studio code launcher to devops applications folder. ----------------------------------
echo "Copying code.desktop launcher to devops 'applications' folder..."
mkdir -p ${devops_home}/provisioners/scripts/centos/applications
cd ${devops_home}/provisioners/scripts/centos/applications
cp -f /usr/share/applications/code.desktop .
chmod 755 ./code.desktop
