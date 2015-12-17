#!/usr/bin/env bash

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
source ~/.bash_profile

echo "init vim ..."
if [ ! -d vim/bundle/vundle ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git vim/bundle/vundle.vim
fi

if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    cmd //c mklink //d "%USERPROFILE%\\vimfiles" "%cd%\\vim"
else
    link vim
fi

link vimrc
vim +BundleInstall! +qall

. ~/.bash_profile

