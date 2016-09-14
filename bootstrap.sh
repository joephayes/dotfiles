#!/usr/bin/env bash

set -e

# bootstrap installs things.

cd $(dirname "$0")

if [ "$(uname)" == "Darwin" ]; then
    source ./osx.sh
fi

if [ ! -f ./vimrc ]; then
    git clone https://github.com/joephayes/dotfiles.git ~/dotfiles
    cd ~/dotfiles
else
    git pull origin master
fi

link() {
    rm -f "$HOME/.$1"

    if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        cmd //c mklink "%USERPROFILE%\\.$1" "%cd%\\$1"
    else
        ln -s "`pwd`/$1" "$HOME/.$1"
    fi
}

echo "init git ..."
link gitconfig
link gitignore
if [ ! -f ~/.gitconfig.local ]; then
    touch ~/.gitconfig.local
fi

echo "init bash ..."
link bash_profile
link bashrc
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
source ~/.bash_profile

echo "init vim ..."
if [ ! -d vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git vim/bundle/Vundle.vim
fi

if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    cmd //c mklink //d "%USERPROFILE%\\vimfiles" "%cd%\\vim"
else
    link vim
fi

link vimrc
vim +BundleInstall! +qall

cd vim/bundle/vim-markdown-composer
export OPENSSL_ROOT_DIR=$(brew --prefix openssl)
export OPENSSL_LIB_DIR=$(brew --prefix openssl)"/lib"
export OPENSSL_INCLUDE_DIR=$(brew --prefix openssl)"/include"
cargo build --release
cd $(dirname "$0")
nvim +UpdateRemotePlugins +qall

source ~/.bash_profile

