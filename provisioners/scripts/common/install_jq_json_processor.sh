#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install jq command-line JSON processor for linux 64-bit.
#
# jq is a lightweight and flexible command-line JSON processor akin to sed, awk, grep, and friends
# for JSON data. It's written in portable C and has zero runtime dependencies, allowing you to
# easily slice, filter, map, and transform structured data.
#
# Usage examples are located at the end of this file.
#
# For more details, please visit:
#   https://jqlang.github.io/jq/
#   https://github.com/jqlang/jq
#   https://jqplay.org/
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# retrieve the current cpu architecture. -----------------------------------------------------------
cpu_arch=$(uname -m)

# install jq yaml processor. -----------------------------------------------------------------------
jq_release="jq-1.8.1"

# set the jq cli binary and sha256 values based on cpu architecture.
if [ "$cpu_arch" = "x86_64" ]; then
  # set the amd64 variables.
  jq_binary="jq-linux-amd64"
  jq_sha256="020468de7539ce70ef1bceaf7cde2e8c4f2ca6c3afb84642aabc5c97d9fc2a0d"
elif [ "$cpu_arch" = "aarch64" ]; then
  # set the arm64 variables.
  jq_binary="jq-linux-arm64"
  jq_sha256="6bc62f25981328edd3cfcfe6fe51b073f2d7e7710d7ef7fcdac28d4e384fc3d4"
else
  echo "Error: Unsupported CPU architecture: '${cpu_arch}'."
  exit 1
fi

# create local bin directory (if needed).
mkdir -p /usr/local/bin
cd /usr/local/bin

# download jq binary from github.com.
rm -f ${jq_binary}
curl --silent --location "https://github.com/jqlang/jq/releases/download/${jq_release}/${jq_binary}" --output ${jq_binary}

# verify the downloaded executable.
echo "${jq_sha256} ${jq_binary}" | sha256sum --check
# ${jq_binary}: OK

# rename executable and change execute permissions.
mv -f ${jq_binary} jq
chown root:root jq
chmod 755 jq

# set jq environment variables.
PATH=/usr/local/bin:$PATH
export PATH

# verify installation.
jq --version

# jq command-line examples. ----------------------------------------------------
# Example #1:
#   GitHub returns nicely formatted JSON. For servers that don't, it can be
#   helpful to pipe the response through jq to pretty-print it. The simplest
#   jq program is the expression '.', which takes the input and produces it
#   unchanged as output.
#
#   $ curl 'https://api.github.com/repos/jqlang/jq/commits?per_page=5' | jq '.'
#
# Example #2:
#  The 'curl' request returns a lot of information, so we'll restrict it down
#  to the most interesting fields. This example takes the first element of the
#  array and builds a new JSON object out of the 'message' and 'name' fields.
#
#   $ curl 'https://api.github.com/repos/jqlang/jq/commits?per_page=5' | jq '.[0] | {message: .commit.message, name: .commit.committer.name}'
#   {
#     "message": "Merge pull request #162 from jqlang/utf8-fixes\n\nUtf8 fixes. Closes #161",
#     "name": "Stephen Dolan"
#   }
