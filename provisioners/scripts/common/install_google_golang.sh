#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Go programming language from Google.
#
# The Go programming language is an open source project to make programmers more productive.
#
# Go is expressive, concise, clean, and efficient. Its concurrency mechanisms make it easy to write
# programs that get the most out of multicore and networked machines, while its novel type system
# enables flexible and modular program construction. Go compiles quickly to machine code yet has
# the convenience of garbage collection and the power of run-time reflection. It's a fast,
# statically typed, compiled language that feels like a dynamically typed, interpreted language.
#
# For more details, please visit:
#   https://go.dev/
#   https://go.dev/doc/
#   https://go.dev/dl/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install go programming language. -----------------------------------------------------------------
go_home="go"
go_release="1.24.5"
go_folder="${go_home}-${go_release}"

# set the go binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  go_binary="${go_home}${go_release}.linux-amd64.tar.gz"
  go_sha256="10ad9e86233e74c0f6590fe5426895de6bf388964210eac34a6d83f38918ecdc"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  go_binary="${go_home}${go_release}.linux-arm64.tar.gz"
  go_sha256="0df02e6aeb3d3c06c95ff201d575907c736d6c62cfa4b6934c11203f1d600ffa"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create apache parent folder.
mkdir -p /usr/local/google
cd /usr/local/google

# download go binary from googleapis.com.
wget --no-verbose https://storage.googleapis.com/golang/${go_binary}

# verify the downloaded binary.
echo "${go_sha256} ${go_binary}" | sha256sum --check
# ${go_home}${go_release}.linux-amd64.tar.gz: OK
# ${go_home}${go_release}.linux-arm64.tar.gz: OK

# extract go binary.
rm -f ${go_home}
tar -zxvf ${go_binary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${go_home}
mv ${go_home} ${go_folder}
ln -s ${go_folder} ${go_home}
rm -f ${go_binary}

# set go home environment variables.
GOROOT=/usr/local/google/${go_home}
export GOROOT
PATH=${GOROOT}/bin:$PATH
export PATH

# verify installation.
go version
