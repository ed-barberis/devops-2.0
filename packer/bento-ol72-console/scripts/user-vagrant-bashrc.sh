# .bashrc

# source global definitions.
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# user specific aliases and functions.
umask 022

# set java home path.
JAVA_HOME=/usr/local/java/jdk180
export JAVA_HOME

# set ant home path.
ANT_HOME=/usr/local/apache/apache-ant-1.9.7
#ANT_HOME=/usr/local/apache/apache-ant-1.9.2
export ANT_HOME

# set maven home environment variables.
M2_HOME=/usr/local/apache/apache-maven-3.3.9
#M2_HOME=/usr/local/apache/apache-maven-3.2.5
export M2_HOME
M2_REPO=$HOME/.m2
export M2_REPO
MAVEN_OPTS=-Dfile.encoding="UTF-8"
export MAVEN_OPTS
M2=$M2_HOME/bin
export M2

# set postman home path.
#POSTMAN_HOME=/usr/local/google/Postman
#export POSTMAN_HOME

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
#PS1="\h[\u] \$ "
#PS1="$(uname -n)[$(whoami)] $ "
#PS1="${reset}${blue}\h${magenta}[${cyan}\u${magenta}]${white}\$ "
PS1="${reset}${cyan}\h${blue}[${green}\u${blue}]${white}\$ "
export PS1

# add local applications to main PATH.
#PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$M2:$POSTMAN_HOME:$PATH
PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$M2:$PATH
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
