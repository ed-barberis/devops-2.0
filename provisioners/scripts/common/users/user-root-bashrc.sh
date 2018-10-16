# .bashrc
# bash resource configuration for devops administrators.

# user 'root' specific aliases and functions.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# source global definitions.
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# user specific aliases and functions.
umask 022

# set java home path.
JAVA_HOME=/usr/local/java/jdk180
export JAVA_HOME

# define prompt code and colors.
reset='\[\e]0;\w\a\]'

black='\[\e[30m\]'
red='\[\e[31m\]'
green='\[\e[32m\]'
yellow='\[\e[33m\]'
blue='\[\e[34m\]'
magenta='\[\e[35m\]'
cyan='\[\e[36m\]'
white='\[\e[0m\]'

# define command line prompt.
#PS1="\h[\u] # "
#PS1="$(uname -n)[$(whoami)] # "
#PS1="${reset}${blue}\h${magenta}[${red}\u${magenta}]${white}# "
PS1="${reset}${cyan}\h${blue}[${red}\u${blue}]${white}# "
export PS1

# add local applications to main PATH.
PATH=$JAVA_HOME/bin:$PATH
export PATH

# set oracle proxy.
#http_proxy=http://www-proxy.us.oracle.com:80
#export http_proxy
#https_proxy=http://www-proxy.us.oracle.com:80
#export https_proxy
#socks_proxy=socks://www-proxy.us.oracle.com:80
#export socks_proxy

# set options.
set -o noclobber
set -o ignoreeof
set -o vi

# set environment variables to configure command history.
HISTSIZE=8192
export HISTSIZE
HISTCONTROL=ignoredups
export HISTCONTROL

# define system alias commands.
alias back='cd $OLDPWD; pwd'
alias c=clear
#alias gvim='gvim -u $HOME/.vim/vimrc.vim'
alias here='cd $here; pwd'
alias more='less'
alias there='cd $there; pwd'
alias vi='vim -u $HOME/.vim/vimrc.vim'
alias vim='vim -u $HOME/.vim/vimrc.vim'

# fix issue with bash shell tab completion.
complete -r

function lsf {
  echo ""
  pwd
  echo ""
  ls -alF $@
  echo ""
}

function psgrep {
  ps -ef | grep "UID\|$@" | grep -v grep
}

function netstatgrep {
  netstat -an | grep "Active\|Proto\|$@"
}

function sclenable {
  scl enable rh-python36 -- bash
}
