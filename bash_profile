if [ "$(uname)" == "Darwin" ]; then
    PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
    export PATH
fi

[[ -r ~/.bashrc ]] && . ~/.bashrc

export CDPATH=".:~/vagrant"

[ -d $HOME/bin ] && export PATH="$HOME/bin:$PATH"
