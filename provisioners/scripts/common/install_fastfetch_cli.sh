#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Fastfetch CLI tool for Linux 64-bit.
#
# Fastfetch is a 'neofetch'-like tool for fetching system information and displaying it prettily.
# It is written mainly in C, with performance and customizability in mind.
#
# Fastfetch is different than Neofetch in the follow areas:
# - Fastfetch is actively maintained.
# - Fastfetch is faster.
# - Fastfetch has a greater number of features, though by default fastfetch only has a few modules
#   enabled; use fastfetch -c all to find what you want.
# - Fastfetch is more configurable. (See the 'Configuration' link below.)
# - Fastfetch is more polished. For example, neofetch prints 555 MiB in the Memory module and
#   23 G in the Disk module, whereas fastfetch prints 555.00 MiB and 22.97 GiB respectively.
# - Fastfetch is more accurate.
#
# For more details, please visit:
#   https://github.com/fastfetch-cli/fastfetch
#   https://github.com/fastfetch-cli/fastfetch/wiki/
#   https://github.com/fastfetch-cli/fastfetch/wiki/Configuration
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install fastfetch cli client. --------------------------------------------------------------------
fastfetch_release="2.37.0"

# set the fastfetch cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  fastfetch_binary="fastfetch-linux-amd64.tar.gz"
  fastfetch_sha256="dec50023c5b884b9a618a2cd51ee7bb8ccb3011ecd9d11681746f6b2481b7feb"

  # set the amd64 download path.
  fastfetch_path="amd64"

elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  fastfetch_binary="fastfetch-linux-aarch64.tar.gz"
  fastfetch_sha256="7bc78e4ac92d9ee4d11b71f5942c0b86b12bd30a9c7c108cb78a753e19385f3d"

  # set the arm64 download path.
  fastfetch_path="aarch64"

else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download fastfetch from github.com.
rm -f ${fastfetch_binary}
curl --silent --location "https://github.com/fastfetch-cli/fastfetch/releases/download/${fastfetch_release}/${fastfetch_binary}" --output ${fastfetch_binary}
chmod 755 ${fastfetch_binary}

# verify the downloaded binary.
echo "${fastfetch_sha256} ${fastfetch_binary}" | sha256sum --check
# fastfetch-linux-amd64.tar.gz: OK
# fastfetch-linux-aarch64.tar.gz: OK

# extract fastfetch cli binary.
rm -f flashfetch
rm -f fastfetch
tar -zxvf ${fastfetch_binary} --no-same-owner --no-overwrite-dir fastfetch-linux-${fastfetch_path}/usr/bin/flashfetch
tar -zxvf ${fastfetch_binary} --no-same-owner --no-overwrite-dir fastfetch-linux-${fastfetch_path}/usr/bin/fastfetch
mv fastfetch-linux-${fastfetch_path}/usr/bin/flashfetch ./flashfetch
mv fastfetch-linux-${fastfetch_path}/usr/bin/fastfetch ./fastfetch
rm -Rf fastfetch-linux-${fastfetch_path}
rm -f ${fastfetch_binary}

# change ownership and execute permissions.
chown root:root flashfetch
chown root:root fastfetch
chmod 755 flashfetch
chmod 755 fastfetch

# set fastfetch environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation. -----------------------------------------------------------------------------
fastfetch --version

# display system information.
fastfetch
