#!/bin/sh -eux
# create default headless (command-line) environment profile for devops 'root' user.

# set default values for input environment variables if not set. -----------------------------------
user_name="root"                                                # user name for 'root' user.
user_group="root"                                               # user login group for 'root' user.
user_home="/root"                                               # user home for 'root' user.
user_prompt_color="red"                                         # user prompt color (defaults to 'red').
                                                                #   valid colors:
                                                                #     'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"                       # [optional] devops home (defaults to '/opt/devops').

# create default environment profile for the user. -------------------------------------------------
root_bashprofile="${devops_home}/provisioners/scripts/common/users/user-root-bash_profile.sh"
root_bashrc="${devops_home}/provisioners/scripts/common/users/user-root-bashrc.sh"

# copy environment profiles to user home.
cd ${user_home}
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f ${root_bashprofile} .bash_profile
cp -f ${root_bashrc} .bashrc

# uncomment proxy environment variables (if set).
proxy_set="${http_proxy:-}"
if [ -n "${proxy_set}" ]; then
  sed -i 's/^#http_proxy/http_proxy/g;s/^#export http_proxy/export http_proxy/g' .bashrc
  sed -i 's/^#https_proxy/https_proxy/g;s/^#export https_proxy/export https_proxy/g' .bashrc
fi

# set user prompt color.
sed -i "s/{red}/{${user_prompt_color}}/g" .bashrc

# remove existing vim profile if it exists. --------------------------------------------------------
if [ -d ".vim" ]; then
  rm -Rf ./.vim
fi

cp -f ${devops_home}/provisioners/scripts/common/tools/vim-files.tar.gz .
tar -zxvf vim-files.tar.gz --no-same-owner --no-overwrite-dir
rm -f vim-files.tar.gz

# configure the vim profile. -----------------------------------------------------------------------
# set current date for temporary filename.
curdate=$(date +"%Y-%m-%d.%H-%M-%S")

# rename the vimrc folder if it exists.
vimrc_home="/root/.vim"
if [ -d "$vimrc_home" ]; then
  # rename the folder using the current date.
  mv ${vimrc_home} /root/vim.${curdate}.orig
fi

# set vim home environment variables.
TERM=xterm-256color
export TERM
PATH=/usr/local/bin:$PATH
export PATH

# download useful vim configuration based on developer pair stations at pivotal labs.
git clone https://github.com/pivotal/vim-config.git ~/.vim
~/.vim/bin/install

# create vimrc local to override default vim configuration.
vimrc_local="/root/.vimrc.local"
if [ -f "$vimrc_local" ]; then
  # rename the folder using the current date.
  mv ${vimrc_local} /root/vimrc_local.${curdate}.orig
fi

cat <<EOF > ${vimrc_local}
" Override default Vim resource configuration.
colorscheme triplejelly                 " Set colorscheme to 'triplejelly'. Default is 'Tomorrow-Night'.
set nofoldenable                        " Turn-off folding of code files. To toggle on/off: use 'zi'.
let g:vim_json_syntax_conceal = 0       " Turn-off concealing of double quotes in 'vim-json' plugin.

" Autoclose 'NERDTree' plugin if it's the only open window left.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
EOF
chown ${user_name}:${user_group} ${vimrc_local}

# initialize the vim plugin manager by opening vim to display the color scheme.
vim -c colorscheme -c quitall

# set directory ownership and file permissions. ----------------------------------------------------
chown -R ${user_name}:${user_group} .
chmod 644 .bash_profile .bashrc
