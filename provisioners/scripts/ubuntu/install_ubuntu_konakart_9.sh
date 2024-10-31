#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install KonaKart Community Java eCommerce application on Ubuntu Linux.
#
# KonaKart is software that implements an enterprise java eCommerce/shopping cart system. It's main
# components are:
#
#   - A shop application used by customers to buy your products. There are actually two storefront
#     applications; one of which is specific for mobile devices.
#   - An Administration application to enable you to manage your store.
#   - Many Customization and Extension features--allowing you to customize and extend the way
#     KonaKart works.
#
# The application uses a MySQL 8.0 back-end (recommended), and requires a default 'konakart'
# schema, which this script imports. MySQL must be running on the same host as the application.
#
# For more details, please visit:
#   https://www.konakart.com/downloads/community_edition/
#   https://www.konakart.com/docs/
#   https://www.konakart.com/docs/AdminAppCredentials.html
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get upgrade -y
#sudo apt-cache search openjdk
#sudo apt install -f openjdk-8-jre-headless -y
#sudo apt-get install mysql-server -y

#sudo /opt/devops-2.0/provisioners/scripts/ubuntu/install_ubuntu_oracle_mysql_community_server_80.sh

echo "Creating KonaKart database..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket; CREATE USER 'konakart'@'localhost' IDENTIFIED BY 'mets1@ppDuser'; ALTER USER 'konakart'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mets1@ppDuser'; GRANT ALL PRIVILEGES ON *.* TO 'konakart'@'localhost' WITH GRANT OPTION; CREATE DATABASE konakart; CREATE USER 'konakart'@'127.0.0.1' IDENTIFIED BY 'mets1@ppDuser'; GRANT ALL ON konakart.* TO 'konakart'@'127.0.0.1'; GRANT ALL ON konakart.* TO 'konakart'@'localhost'; CREATE USER 'monitor'@'localhost' IDENTIFIED BY 'mets1@ppDuser'; GRANT ALL PRIVILEGES ON *.* TO 'monitor'@'localhost' WITH GRANT OPTION; CREATE USER 'monitor'@'%' IDENTIFIED BY 'mets1@ppDuser'; GRANT ALL PRIVILEGES ON *.* TO 'monitor'@'%' WITH GRANT OPTION;"
sudo sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql
sudo apt-get install build-essential -y
sudo apt-get install python3-venv -y

echo "Downloading KonaKart 9.6.0.0 Linux binary..."
sudo curl --location https://www.konakart.com/kkcounter/click.php?id=5 --output /tmp/KonaKart-9.6.0.0-Linux-Install-64
sudo chmod 755 /tmp/KonaKart-9.6.0.0-Linux-Install-64

echo "Downloading KonaKart 9.6.0.0 Zip file..."
cd ~
curl --location https://www.konakart.com/kkcounter/click.php?id=3 --output KonaKart-9.6.0.0.zip
sudo chmod 644 KonaKart-9.6.0.0.zip
unzip KonaKart-9.6.0.0.zip
cd ~/konakart
find . -name '*\.sh' -exec chmod 755 {} \; -print

echo "Installing KonaKart 9.6.0.0..."
cd ~
sudo /tmp/KonaKart-9.6.0.0-Linux-Install-64 -S -DDatabaseType mysql -DDatabaseUrl jdbc:mysql://localhost:3306/konakart -DDatabaseUsername konakart -DDatabasePassword mets1@ppDuser -DJavaJRE /usr/local/java/jdk180

echo "Create KonaKart Demo application..."
cd ~/konakart/database/MySQL/
mysql -p konakart --user=konakart --password=mets1@ppDuser < ~/konakart/database/MySQL/konakart_demo.sql

echo "Starting KonaKart..."
~/konakart/bin/startkonakart.sh

echo "Installation complete."
