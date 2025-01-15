#!/bin/sh -eux
#---------------------------------------------------------------------------------------------------
# Install Git distributed version control system.
#
# Git is a fast, scalable, distributed revision control system with an unusually rich command set
# that provides both high-level operations and full access to internals.
#
# For more details, please visit:
#   https://git-scm.com/
#   https://github.com/git/git/blob/master/INSTALL
#
# NOTE: Script should be run with 'root' privilege.
#---------------------------------------------------------------------------------------------------

# set default values for input environment variables if not set. -----------------------------------
# [OPTIONAL] git flow install parameters [w/ defaults].
user_name="${user_name:-vagrant}"                               # user name.
user_group="${user_group:-vagrant}"                             # user login group.
git_release="${git_release:-2.48.1}"                            # git release version.

# install tools needed to build git from source. ---------------------------------------------------
yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum -y install gcc perl-ExtUtils-MakeMaker

# install git binaries from source. ----------------------------------------------------------------
githome="git"
gitfolder="git-${git_release}"
gitbinary="${gitfolder}.tar.gz"

# create git source parent folder.
mkdir -p /usr/local/src/git
cd /usr/local/src/git

# download git source from kernel.org.
curl --silent --location https://mirrors.edge.kernel.org/pub/software/scm/git/${gitbinary} --output ${gitbinary}

# extract git source.
rm -Rf ${gitfolder}
tar -zxvf ${gitbinary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${gitfolder}
rm -f ${gitbinary}

# build and install git binaries.
cd ${gitfolder}
CFLAGS="-DNO_UNCOMPRESS2"
export CFLAGS

# set path environment variable for '/usr/local/bin'.
PATH=/usr/local/bin:$PATH
export PATH

./configure
make prefix=/usr/local/git/${gitfolder} all
make prefix=/usr/local/git/${gitfolder} install

# create soft link to git binary.
cd /usr/local/git
rm -f ${githome}
ln -s ${gitfolder} ${githome}

# set git home environment variables.
GIT_HOME=/usr/local/git/${githome}
export GIT_HOME
PATH=${GIT_HOME}/bin:$PATH
export PATH

# verify installation.
git --version

# install git man pages. ---------------------------------------------------------------------------
gitmanbinary="git-manpages-${git_release}.tar.gz"

# create git man pages parent folder if needed.
mkdir -p /usr/share/man
cd /usr/share/man

# download git man pages from kernel.org.
curl --silent --location https://mirrors.edge.kernel.org/pub/software/scm/git/${gitmanbinary} --output ${gitmanbinary}

# extract git man pages.
tar -zxvf ${gitmanbinary} --no-same-owner --no-overwrite-dir
rm -f ${gitmanbinary}

# install git completion for bash. -----------------------------------------------------------------
gcbin=".git-completion.bash"
gcfolder="/home/${user_name}"

# download git completion for bash from github.com.
rm -f ${gcfolder}/${gcbin}
curl --silent --location "https://raw.githubusercontent.com/git/git/v${git_release}/contrib/completion/git-completion.bash" --output ${gcfolder}/${gcbin}

chown -R ${user_name}:${user_group} ${gcfolder}/${gcbin}
chmod 644 ${gcfolder}/${gcbin}
