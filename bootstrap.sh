#!/usr/bin/env bash

# bootstrap installs things.

cd $(dirname "$0")

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
link gitattributes
link gitignore

echo "init bash ..."
link bashrc
source ~/.bashrc

echo "init vim ..."
if [ ! -d vim/bundle/vundle ]; then
    git clone https://github.com/gmarik/vundle.git vim/bundle/vundle
fi

if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    cmd //c mklink //d "%USERPROFILE%\\vimfiles" "%cd%\\vim"
else
    link vim
fi

link vimrc
vim +BundleInstall! +qall

. ~/.bashrc
