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
go_release="1.23.4"
go_folder="${go_home}-${go_release}"

# set the go binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  go_binary="${go_home}${go_release}.linux-amd64.tar.gz"
  go_sha256="6924efde5de86fe277676e929dc9917d466efa02fb934197bc2eba35d5680971"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  go_binary="${go_home}${go_release}.linux-arm64.tar.gz"
  go_sha256="16e5017863a7f6071363782b1b8042eb12c6ca4f4cd71528b2123f0a1275b13e"
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
