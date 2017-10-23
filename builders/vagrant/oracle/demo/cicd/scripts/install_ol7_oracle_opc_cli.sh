#!/bin/sh -eux
# install oracle public cloud (opc) cli client on oracle linux 7.x.

# create temporary opc cli directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle/opc-cli
cd /tmp/scripts/oracle/opc-cli

# install oracle public cloud (opc) cli client. --------------------------------
username="<username>"
password="<password>"
identity_domain="<identity_domain>"
opc_datacenter="<opc_datacenter - such as 'em2'>"
opc_compute_zone="<opc_compute_zone - such as 'z17'>"
opc_cli_version="<opc_cli_version - such as '17.2.2'>"
opc_cli_binary="opc-cli.${opc_cli_version}.zip"
opc_cli_repo="opc-cli-${opc_cli_version}.x86_64.rpm"

# retrieve and install the opc-cli from the oracle cloud (local if needed).
#wget --no-verbose --load-cookies=cookies.txt --no-check-certificate http://download.oracle.com/otn/java/cloud-service/${opc_cli_binary}
cp -f /tmp/scripts/oracle/tools/${opc_cli_binary} .
chmod 644 ${opc_cli_binary}
unzip ${opc_cli_binary}
yum -y install ${opc_cli_repo}

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d")

# configure the opc-cli client. ------------------------------------------------
# add environment variables to '.bashrc' for user 'vagrant'.
opc_cli_profile_directory="/home/vagrant/.opc/profiles"
opc_cli_profile_file="profile-${identity_domain}"

cd /home/vagrant
awk -v opc_profile_directory=${opc_cli_profile_directory} -v opc_profile_file=${opc_cli_profile_file} -f /vagrant/scripts/enable_ol7_oracle_opc_cli.awk /vagrant/scripts/users/user-vagrant-bashrc.sh > .bashrc.${curdate}.opc-cli
mv -f .bashrc.${curdate}.opc-cli .bashrc

chown vagrant:vagrant .bashrc
chmod 644 .bashrc

# create opc-cli client password file.
touch ${identity_domain}-passwd.txt
echo "${password}" >> ${identity_domain}-passwd.txt
chown vagrant:vagrant ${identity_domain}-passwd.txt
chmod 600 ${identity_domain}-passwd.txt

# create opc-cli profile.
mkdir -p ${opc_cli_profile_directory}
cd ${opc_cli_profile_directory}

touch ${opc_cli_profile_file}
chmod 600 ${opc_cli_profile_file}

echo "{" >> ${opc_cli_profile_file}
echo "  \"global\": {" >> ${opc_cli_profile_file}
echo "    \"format\": \"json\"," >> ${opc_cli_profile_file}
echo "    \"debug-requests\": false" >> ${opc_cli_profile_file}
echo "  }," >> ${opc_cli_profile_file}
echo "  \"compute\": {" >> ${opc_cli_profile_file}
echo "    \"user\": \"/Compute-${identity_domain}/${username}\"," >> ${opc_cli_profile_file}
echo "    \"password-file\": \"/home/vagrant/${identity_domain}-passwd.txt\"," >> ${opc_cli_profile_file}
echo "    \"endpoint\": \"api-${opc_compute_zone}.compute.${opc_datacenter}.oraclecloud.com\"" >> ${opc_cli_profile_file}
echo "  }" >> ${opc_cli_profile_file}
echo "}" >> ${opc_cli_profile_file}

# change ownership for the entire 'vagrant' user directory structure.
cd /home/vagrant
chown -R vagrant:vagrant .

# verify the opc-cli configuration. --------------------------------------------
opc --version

# run the script.
#runuser -c "/tmp/scripts/oracle/opc-cli/${opccli_script}" - vagrant
#runuser -c "opc -p profile-${identify_domain} -pd /home/vagrant/.opc/profiles compute instances list /Compute-gse00001969/cloud.admin" - vagrant
runuser -c "opc --profile profile-${identity_domain} --profile-directory /home/vagrant/.opc/profiles compute instances list /Compute-gse00001969/cloud.admin" - vagrant

# change ownership for the entire temporary directory structure.
cd /tmp/scripts
chown -R vagrant:vagrant .
