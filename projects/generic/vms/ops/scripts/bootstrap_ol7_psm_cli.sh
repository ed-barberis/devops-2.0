#!/bin/sh -eux
# install oracle paas service manager (psm) cli client on oracle linux 7.x.

# create temporary scripts directory. ------------------------------------------
mkdir -p /tmp/scripts/oracle
cd /tmp/scripts/oracle

# update the repository list. --------------------------------------------------
yum repolist

# install python 3.3. ----------------------------------------------------------
yum -y install python33
scl enable python33 -- python --version

# install python 3.3 pip. ------------------------------------------------------
wget --no-verbose https://bootstrap.pypa.io/get-pip.py
scl enable python33 -- python /tmp/scripts/oracle/get-pip.py
scl enable python33 -- pip --version
scl enable python33 -- pip3 --version

# install oracle paas service manager (psm) cli client. ------------------------
username="cloud.admin"
password="Shining@2YouTH"
identity_domain="gse00001969"

# retrieve and install the psm-cli from the oracle cloud.
curl --silent --request GET --user ${username}:${password} --header X-ID-TENANT-NAME:${identity_domain} https://psm.europe.oraclecloud.com/paas/core/api/v1.1/cli/${identity_domain}/client --output psmcli.zip
scl enable python33 -- pip3 install --upgrade psmcli.zip
runuser -c "scl enable python33 -- psm --version" - vagrant

# configure the psm-cli client. ------------------------------------------------
psm_setup_cmd=$(printf "psm setup <<< \$\'%s\\\\n%s\\\\n%s\\\\n%s\\\\n%s\\\\n%s\\\\n\'\n" ${username} ${password} ${password} ${identity_domain} emea json)
runuser -c "scl enable python33 -- eval ${psm_setup_cmd}" - vagrant

# verify the psm-cli configuration. --------------------------------------------
runuser -c "scl enable python33 -- psm dbcs services" - vagrant
runuser -c "scl enable python33 -- psm jcs services" - vagrant

# change ownership for the entire temporary directory structure.
cd /tmp/scripts
chown -R vagrant:vagrant .
