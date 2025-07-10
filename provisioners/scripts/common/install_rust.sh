#!/bin/bash -eux
#---------------------------------------------------------------------------------------------------
# Install and manage Rust using the 'rustup' tool.
#
# The Rust programming language is an open source systems programming language empowering everyone
# to build reliable and efficient software. Rust provides control of low-level details along with
# high-level ergonomics, allowing you to improve productivity and eliminate the hassle
# traditionally associated with low-level languages. Why Rust?
#
# - Performance: Rust is blazingly fast and memory-efficient: with no runtime or garbage collector,
#   it can power performance-critical services, run on embedded devices, and easily integrate with
#   other languages.
# - Reliability: Rust’s rich type system and ownership model guarantee memory-safety and
#   thread-safety--enabling you to eliminate many classes of bugs at compile-time.
# - Productivity: Rust has great documentation, a friendly compiler with useful error messages and
#   top-notch tooling, including an integrated package manager and build tool, smart multi-editor
#   support with auto-completion and type inspections, an auto-formatter, and more.
#
# For more details, please visit:
#   https://www.rust-lang.org/
#   https://www.rust-lang.org/tools/install
#   https://doc.rust-lang.org/book/title-page.html
#   https://doc.rust-lang.org/book/ch01-02-hello-world.html
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] rust install parameters [w/ defaults].
user_name="${user_name:-vagrant}"

# define usage function. ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
    [root]# export user_name="vagrant"                          # user name.
    [root]# $0
EOF
}

# validate environment variables. ------------------------------------------------------------------
if [ -z "$user_name" ]; then
  echo "Error: 'user_name' environment variable not set."
  usage
  exit 1
fi

if [ "$user_name" = "root" ]; then
  echo "Error: 'user_name' should NOT be 'root'."
  usage
  exit 1
fi

# download and install rust programming language. --------------------------------------------------
runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs --output rustup.sh" - ${user_name}
runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} chmod 755 ./rustup.sh" - ${user_name}
runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} ./rustup.sh -y" - ${user_name}

# verify installation.
runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} rustc --version" - ${user_name}

# cleanup 'rustup' installer. ----------------------------------------------------------------------
runuser -c "PATH=/home/${user_name}/.cargo/bin:/usr/local/bin:${PATH} rm -f ./rustup.sh" - ${user_name}
