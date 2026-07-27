# @(#).bashrc       1.0 2026/07/24 SMI
# bash resource configuration for devops users.

# source global definitions.
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# user specific aliases and functions.
umask 022

# set java home path.
#JAVA_HOME=/usr/local/java/jdk180
#JAVA_HOME=/usr/local/java/jdk11
#JAVA_HOME=/usr/local/java/jdk17
#JAVA_HOME=/usr/local/java/jdk21
#JAVA_HOME=/usr/local/java/jdk25
JAVA_HOME=/usr/local/java/jdk26
export JAVA_HOME

# set ant home path.
ANT_HOME=/usr/local/apache/apache-ant
export ANT_HOME

# set maven home environment variables.
M2_HOME=/usr/local/apache/apache-maven
export M2_HOME
M2_REPO=$HOME/.m2
export M2_REPO
MAVEN_OPTS=-Dfile.encoding="UTF-8"
export MAVEN_OPTS
M2=$M2_HOME/bin
export M2

# set groovy home environment variables.
GROOVY_HOME=/usr/local/apache/groovy
export GROOVY_HOME

# set gradle home path.
GRADLE_HOME=/usr/local/gradle/gradle
export GRADLE_HOME

# set git home paths.
GIT_HOME=/usr/local/git/git
export GIT_HOME
GIT_FLOW_HOME=/usr/local/git/gitflow
export GIT_FLOW_HOME

# set go home paths.
GOROOT=/usr/local/google/go
export GOROOT
GOPATH=$HOME/go
export GOPATH

# set scala-lang home path.
SCALA_HOME=/usr/local/scala/scala-lang
export SCALA_HOME

# set scala-sbt home path.
# NOTE: sbt 1.7.0 introduced an out of memory issue when '-Xms' heap size is set or the default is used.
#       expliciting setting 'SBT_OPTS' to exclude it solved the problem.
SBT_OPTS="-Xmx1024m -Xss4m -XX:ReservedCodeCacheSize=128m"
export SBT_OPTS
SBT_HOME=/usr/local/scala/scala-sbt
export SBT_HOME

# set rust toolchain home path for cargo.
CARGO_HOME=$HOME/.cargo
export CARGO_HOME

# set postman home path.
POSTMAN_HOME=/usr/local/google/Postman
export POSTMAN_HOME

# trim excess version characters from amazon linux 2023 release.
if [ "${user_host_os:0:17}" = "Amazon Linux 2023" ]; then
  user_host_os="${user_host_os:0:17}"
fi

# if needed, apply fix for incompatible openssl.
case $user_host_os in
  "Amazon Linux 2023"|"Ubuntu 22.04.5 LTS")
    OPENSSL_CONF=/dev/null
    export OPENSSL_CONF
    ;;

  *)
    ;;
esac

# set devops 2.0 home path.
devops_home=/opt/devops-2.0
export devops_home

# set kubectl config path.
KUBECONFIG=$HOME/.kube/config
export KUBECONFIG

# set splunk enterprise home path.
SPLUNK_HOME=/opt/splunk
export SPLUNK_HOME

# define prompt code and colors.
reset='\[\e]0;\w\a\]'
bold='\[\e[1m\]'

# standard colors.
black='\[\e[30m\]'
red='\[\e[31m\]'
green='\[\e[32m\]'
yellow='\[\e[33m\]'
blue='\[\e[34m\]'
magenta='\[\e[35m\]'
cyan='\[\e[36m\]'
white='\[\e[0m\]'

light_gray='\[\e[37m\]'
dark_gray='\[\e[90m\]'
light_red='\[\e[91m\]'
light_green='\[\e[92m\]'
light_yellow='\[\e[93m\]'
light_blue='\[\e[94m\]'
light_magenta='\[\e[95m\]'
light_cyan='\[\e[96m\]'

# true colors.
orange='\[\e[38;2;255;165;0m\]'
red_orange='\[\e[38;2;255;83;73m\]'

# define command line prompt.
#PS1="\h[\u] \$ "
#PS1="$(uname -n)[$(whoami)] $ "
#PS1="${reset}${blue}\h${magenta}[${cyan}\u${magenta}]${white}\$ "
PS1="${reset}${cyan}\h${blue}[${green}\u${blue}]${white}\$ "
export PS1

# add local applications to main PATH.
PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$M2:$GROOVY_HOME/bin:$GRADLE_HOME/bin:$GIT_HOME/bin:$GIT_FLOW_HOME/bin:$GOROOT/bin:$GOPATH/bin:$SCALA_HOME/bin:$SBT_HOME/bin:$CARGO_HOME/bin:$POSTMAN_HOME:$HOME/.local/bin:$PATH
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

# process bash completion files.
bcfiles=( .docker-completion.sh .docker-compose-completion.sh .git-completion.bash .git-flow-completion.bash )

for bcfile in ${bcfiles[@]}; do
  # source bash completion file.
  if [ -f $HOME/${bcfile} ]; then
    . $HOME/${bcfile}
  fi
done

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

# install tab auto completion for hashicorp tools.
complete -C /usr/local/bin/consul consul
complete -C /usr/local/bin/packer packer
complete -C /usr/local/bin/terraform terraform
complete -C /usr/local/bin/vault vault
