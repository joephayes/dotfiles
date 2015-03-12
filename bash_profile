if [ "$(uname)" == "Darwin" ]; then
    $PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

