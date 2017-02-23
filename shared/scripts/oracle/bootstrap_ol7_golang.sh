#!/bin/sh -eux
# install go programming language from google.

# install go programming language. ---------------------------------------------
gorelease="1.8"
gobinary="go${gorelease}.linux-amd64.tar.gz"
gofolder="go-${gorelease}"

# create apache parent folder.
mkdir -p /usr/local/google
cd /usr/local/google

# download go binary from googleapis.com.
wget --no-verbose https://storage.googleapis.com/golang/${gobinary}

# extract go binary.
tar -zxvf ${gobinary} --no-same-owner --no-overwrite-dir
chown -R root:root ./go
mv go ${gofolder}
ln -s ${gofolder} go
rm -f ${gobinary}

# set go home environment variables.
GOROOT=/usr/local/google/go
export GOROOT
PATH=${GOROOT}/bin:$PATH
export PATH

# verify installation.
go version
