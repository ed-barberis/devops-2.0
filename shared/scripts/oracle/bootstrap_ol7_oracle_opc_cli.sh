#!/bin/sh -eux
# install oracle public cloud (opc) cli client on oracle linux 7.x.

# create temporary opc cli directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle/opc-cli
cd /tmp/scripts/oracle/opc-cli

# update the repository list. --------------------------------------------------
yum repolist

# verify python 2.x setup tools. -----------------------------------------------
python --version
pip --version
easy_install --version

# install oracle public cloud (opc) cli client. --------------------------------
username="cloud.admin"
password="Shining@2YouTH"
identity_domain="gse00001969"
opc_datacenter="em2"
opc_compute_zone="z17"
opc_cli_binary="opc-cli-1.1.0.zip"

# retrieve and install the opc-cli from the oracle cloud (local if needed).
#wget --no-verbose --load-cookies=cookies.txt --no-check-certificate http://download.oracle.com/otn/java/cloud-service/${opc_cli_binary}
cp -f /tmp/scripts/oracle/tools/${opc_cli_binary} .
chmod 644 ${opc_cli_binary}
unzip ${opc_cli_binary}
easy_install python-dateutil
easy_install opc_cli_1.0.0_py2.6.egg

# set current date for temporary filename. -------------------------------------
curdate=$(date +"%Y-%m-%d")

# configure the opc-cli client. ------------------------------------------------
cd /home/vagrant
opc_api_var="https://api-${opc_compute_zone}.compute.${opc_datacenter}.oraclecloud.com"
opc_user_var="/Compute-${identity_domain}/${username}"
awk -v opc_api=${opc_api_var} -v opc_user=${opc_user_var} -f /tmp/scripts/oracle/enable_ol7_opc_cli.awk /tmp/scripts/oracle/users/user-vagrant-bashrc.sh > .bashrc.${curdate}.opc-cli
mv -f .bashrc.${curdate}.opc-cli .bashrc

chown vagrant:vagrant .bashrc
chmod 644 .bashrc

# create opc-cli client password file.
touch ${identity_domain}-passwd.txt
echo "${password}" >> ${identity_domain}-passwd.txt
chown vagrant:vagrant ${identity_domain}-passwd.txt
chmod 600 ${identity_domain}-passwd.txt

# verify the opc-cli configuration. --------------------------------------------
oracle-compute --print_cli_version

# create script to list oracle compute instances in json format.
opccli_script="opc-cli-list-instances.sh"

cd /tmp/scripts/oracle/opc-cli
touch ${opccli_script}
echo "#!/bin/sh" >> ${opccli_script}
echo "" >> ${opccli_script}
echo "OPC_API=https://api-${opc_compute_zone}.compute.${opc_datacenter}.oraclecloud.com" >> ${opccli_script}
echo "export OPC_API" >> ${opccli_script}
echo "OPC_USER=/Compute-${identity_domain}/${username}" >> ${opccli_script}
echo "export OPC_USER" >> ${opccli_script}
echo "" >> ${opccli_script}
echo "oracle-compute --pass=/home/vagrant/${identity_domain}-passwd.txt list instance /Compute-${identity_domain}/${username} --format=json" >> ${opccli_script}

chown -R vagrant:vagrant .
chmod 755 ${opccli_script}

# run the script.
runuser -c "/tmp/scripts/oracle/opc-cli/${opccli_script}" - vagrant

# change ownership for the entire temporary directory structure.
cd /tmp/scripts
chown -R vagrant:vagrant .
