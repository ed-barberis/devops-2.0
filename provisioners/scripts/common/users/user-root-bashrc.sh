# @(#).bashrc       1.0 2025/03/19 SMI
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
#JAVA_HOME=/usr/local/java/jdk180
#JAVA_HOME=/usr/local/java/jdk11
JAVA_HOME=/usr/local/java/jdk17
#JAVA_HOME=/usr/local/java/jdk21
#JAVA_HOME=/usr/local/java/jdk23
#JAVA_HOME=/usr/local/java/jdk24
export JAVA_HOME

# set maven home environment variables.
M2_HOME=/usr/local/apache/apache-maven
export M2_HOME
M2_REPO=$HOME/.m2
export M2_REPO
MAVEN_OPTS=-Dfile.encoding="UTF-8"
export MAVEN_OPTS
M2=$M2_HOME/bin
export M2

# set git home paths.
GIT_HOME=/usr/local/git/git
export GIT_HOME
GIT_FLOW_HOME=/usr/local/git/gitflow
export GIT_FLOW_HOME

# set devops 2.0 home path.
devops_home=/opt/devops-2.0
export devops_home

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
PATH=$JAVA_HOME/bin:$M2:$GIT_HOME/bin:$GIT_FLOW_HOME/bin:$HOME/.local/bin:$PATH
export PATH

# set corporate proxy.
#http_proxy=http://proxy.esl.cisco.com:8080
#export http_proxy
#https_proxy=http://proxy.esl.cisco.com:8080
#export https_proxy

# set options.
set -o noclobber
set -o ignoreeof
set -o vi

# set environment variables to configure command history.
HISTSIZE=16384
export HISTSIZE
HISTCONTROL=ignoredups
export HISTCONTROL

# define system alias commands.
alias back='cd $OLDPWD; pwd'
alias c=clear
alias devopshome='cd $devops_home; pwd'
#alias gvim='gvim -u $HOME/.vim/vimrc.vim'
alias here='cd $here; pwd'
alias more='less'
alias there='cd $there; pwd'
alias vi='vim'

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
  netstat -ant | grep "Active\|Proto\|$@"
}

function sclenable {
  scl enable rh-python36 -- bash
}
