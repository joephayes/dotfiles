[[ -s ~/.profile ]] && . ~/.profile # Load the default .profile

export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="${JAVA_HOME}/bin"
export CDPATH=".:~/dev"
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOROOT/bin
export HISTCONTROL="erasedups:ignorespace"
export HISTSIZE=10000
export HISTFILESIZE=10000
export CLICOLOR=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=svn
export GIT_PROMPT_THEME=Solarized
export EDITOR=/usr/local/bin/nvim
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/bin
export PATH=$PATH:/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:/usr/sbin
export PATH=$PATH:/sbin
export PATH=/Library/Frameworks/Python.framework/Versions/3.9/bin:$PATH

# Fixes "RE error: illegal byte sequence" for sed search/replace on osx
# http://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x
# export LC_CTYPE=C
# export LANG=C

[[ -f ~/.bashrc ]] && . ~/.bashrc
