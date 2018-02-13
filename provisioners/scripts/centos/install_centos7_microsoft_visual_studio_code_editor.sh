#!/bin/sh -eux
# install visual studio code ide by microsoft.

# set default value for devops home environment variable if not set. -----------
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').

# create scripts directory (if needed). ----------------------------------------
mkdir -p ${devops_home}/provisioners/scripts/centos
cd ${devops_home}/provisioners/scripts/centos

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d")

# install visual studio code editor. -------------------------------------------
# retrieve download location and repository of latest release.
#curl --silent --dump-header curl-get-code.${curdate}.out1 https://go.microsoft.com/fwlink/?LinkID=620884 --output /dev/null
#curl --silent --dump-header curl-vscode.${curdate}.out1 https://vscode-update.azurewebsites.net/latest/linux-x64/stable --output /dev/null
#curl --silent --dump-header curl-get-code.${curdate}.out1 https://go.microsoft.com/fwlink/?LinkID=760867 --output /dev/null
curl --silent --dump-header curl-vscode.${curdate}.out1 https://vscode-update.azurewebsites.net/latest/linux-rpm-x64/stable --output /dev/null
tr -d '\r' < curl-vscode.${curdate}.out1 > curl-vscode.${curdate}.out2
vscodelocation=$(awk '/Location/ {print $2}' curl-vscode.${curdate}.out2)
vscoderepo=$(awk '/Location/ {print $2}' curl-vscode.${curdate}.out2 | awk -F "/" '{print $6}')
rm -f curl-vscode.${curdate}.out1
rm -f curl-vscode.${curdate}.out2

# download visual studio code repository from microsoft.
wget --no-verbose ${vscodelocation}
yum repolist
yum -y install ${vscoderepo}

# verify installation.
#code --version

# install visual studio code launcher on user desktop. -------------------------
echo "Installing code.desktop on user desktop..."
mkdir -p /home/vagrant/Desktop
cd /home/vagrant/Desktop
cp -f /usr/share/applications/code.desktop .

chown -R vagrant:vagrant .
chmod 755 ./code.desktop
