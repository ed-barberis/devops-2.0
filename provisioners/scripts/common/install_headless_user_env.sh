#!/bin/sh -eux
# create default headless (command-line) environment profile for devops user.

# set default values for input environment variables if not set. -----------------------------------
user_name="${user_name:-}"
user_group="${user_group:-}"
user_home="${user_home:-}"
user_docker_profile="${user_docker_profile:-false}"
user_prompt_color="${user_prompt_color:-green}"
d_completion_release="${d_completion_release:-20.10.3}"
dc_completion_release="${dc_completion_release:-1.28.2}"

# set default value for devops home environment variable if not set. -------------------------------
devops_home="${devops_home:-/opt/devops}"

# define usage function. ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with correct privilege for the given user name.
  Example:
    [root]# export user_name="user1"                            # user name.
    [root]# export user_group="group1"                          # user login group.
    [root]# export user_home="/home/user1"                      # [optional] user home directory path.
    [root]# export user_docker_profile="true"                   # [optional] user docker profile (defaults to 'false').
    [root]# export user_prompt_color="yellow"                   # [optional] user prompt color (defaults to 'green').
                                                                #            valid colors:
                                                                #              'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'
                                                                #
    [root]# export d_completion_release="20.10.3"               # [optional] docker completion for bash release (defaults to '20.10.3').
    [root]# export dc_completion_release="1.28.2"               # [optional] docker compose completion for bash release (defaults to '1.28.2').
    [root]# export devops_home="/opt/devops"                    # [optional] devops home (defaults to '/opt/devops').
    [root]# $0
EOF
}

# validate environment variables. ------------------------------------------------------------------
if [ -z "$user_name" ]; then
  echo "Error: 'user_name' environment variable not set."
  usage
  exit 1
fi

if [ -z "$user_group" ]; then
  echo "Error: 'user_group' environment variable not set."
  usage
  exit 1
fi

if [ -n "$user_prompt_color" ]; then
  case $user_prompt_color in
      black|blue|cyan|green|magenta|red|white|yellow)
        ;;
      *)
        echo "Error: invalid 'user_prompt_color'."
        usage
        exit 1
        ;;
  esac
fi

if [ "$user_name" == "root" ]; then
  echo "Error: 'user_name' should NOT be 'root'."
  usage
  exit 1
fi

# if not set, retrieve user home directory path.
if [ -z "$user_home" ]; then
  user_home=$(eval echo "~${user_name}")
fi

# create default environment profile for the user. -------------------------------------------------
user_bashprofile="${devops_home}/provisioners/scripts/common/users/user-vagrant-bash_profile.sh"
user_bashrc="${devops_home}/provisioners/scripts/common/users/user-vagrant-bashrc.sh"

# copy environment profiles to user home.
cd ${user_home}
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

cp -f ${user_bashprofile} .bash_profile
cp -f ${user_bashrc} .bashrc

# uncomment proxy environment variables (if set).
proxy_set="${http_proxy:-}"
if [ -n "${proxy_set}" ]; then
  sed -i 's/^#http_proxy/http_proxy/g;s/^#export http_proxy/export http_proxy/g' .bashrc
  sed -i 's/^#https_proxy/https_proxy/g;s/^#export https_proxy/export https_proxy/g' .bashrc
fi

# set user prompt color.
sed -i "s/{green}/{${user_prompt_color}}/g" .bashrc

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
vimrc_home="${user_home}/.vim"
if [ -d "$vimrc_home" ]; then
  # rename the folder using the current date.
  mv ${vimrc_home} ${user_home}/vim.${curdate}.orig
fi

# create vimrc local to override default vim configuration.
vimrc_local="${user_home}/.vimrc.local"
if [ -f "$vimrc_local" ]; then
  # rename the folder using the current date.
  mv ${vimrc_local} ${user_home}/vimrc_local.${curdate}.orig
fi

# create temporary vimrc local to fix issue during install with snipmate parser.
cat <<EOF > ${vimrc_local}
" Temporary override of default Vim resource configuration.
let g:snipMate = {'snippet_version': 1} " Use the new version of the SnipMate parser.
EOF
chown ${user_name}:${user_group} ${vimrc_local}

# download and install useful vim configuration based on developer pair stations at pivotal labs.
runuser -c "git clone https://github.com/pivotal-legacy/vim-config.git ~/.vim" - ${user_name}
runuser -c "TERM=xterm-256color ~/.vim/bin/install" - ${user_name}

# create final vimrc local file.
rm -f ${vimrc_local}
cat <<EOF > ${vimrc_local}
" Override default Vim resource configuration.
colorscheme triplejelly                 " Set colorscheme to 'triplejelly'. Default is 'Tomorrow-Night'.
set nofoldenable                        " Turn-off folding of code files. To toggle on/off: use 'zi'.
let g:vim_json_syntax_conceal = 0       " Turn-off concealing of double quotes in 'vim-json' plugin.
let g:snipMate = {'snippet_version': 1} " Use the new version of the SnipMate parser.

" Autoclose 'NERDTree' plugin if it's the only open window left.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
EOF
chown ${user_name}:${user_group} ${vimrc_local}

# initialize the vim plugin manager by opening vim to display the color scheme.
runuser -c "TERM=xterm-256color vim -c colorscheme -c quitall" - ${user_name}

# set directory ownership and file permissions. ----------------------------------------------------
chown -R ${user_name}:${user_group} .
chmod 644 .bash_profile .bashrc

# create docker profile for the user. --------------------------------------------------------------
if [ "$user_docker_profile" == "true" ]; then
  # add user to the 'docker' group.
  usermod -aG docker ${user_name}

  # install docker completion for bash.
  d_completion_binary=".docker-completion.sh"

  # download docker completion for bash from github.com.
  rm -f ${user_home}/${d_completion_binary}
  curl --silent --location "https://github.com/docker/cli/raw/v${d_completion_release}/contrib/completion/bash/docker" --output ${user_home}/${d_completion_binary}
  chown -R ${user_name}:${user_group} ${user_home}/${d_completion_binary}
  chmod 644 ${user_home}/${d_completion_binary}

  # install docker compose completion for bash.
  dc_completion_binary=".docker-compose-completion.sh"

  # download docker completion for bash from github.com.
  rm -f ${user_home}/${dc_completion_binary}
  curl --silent --location "https://github.com/docker/compose/raw/${dc_completion_release}/contrib/completion/bash/docker-compose" --output ${user_home}/${dc_completion_binary}
  chown -R ${user_name}:${user_group} ${user_home}/${dc_completion_binary}
  chmod 644 ${user_home}/${dc_completion_binary}
fi
