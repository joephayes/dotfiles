#!/usr/bin/env bash

set -e

# bootstrap installs things.

isMac() {
  if [ "$(uname)" == "Darwin" ]; then
    return 0
  else
    return 1
  fi
}

isWindows() {
  if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    return 0
  else
    return 1
  fi
}

link() {
  rm -f "$HOME/.$1"

  if isWindows; then
    cmd //c mklink "%USERPROFILE%\\.$1" "%cd%\\$1"
  else
    ln -s "`pwd`/$1" "$HOME/.$1"
  fi
}

cd $(dirname "$0")

if isMac; then
  source ./osx.sh
fi

if [ ! -f ./vimrc ]; then
  git clone https://github.com/joephayes/dotfiles.git ~/dotfiles
  cd ~/dotfiles
else
  git pull origin master
fi

echo "init git ..."
link gitconfig
link gitignore
if [ ! -f ~/.gitconfig.local ]; then
    touch ~/.gitconfig.local
fi

echo "init bash ..."
link bash_profile
link bashrc
link bash_aliases
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh

echo "init tmux"
link tmux.conf

if "test ! -d ~/.tmux/plugins/tpm" \
      "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"

      run '~/.tmux/plugins/tpm/tpm'

echo "init vim ..."
if [ ! -d vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git vim/bundle/Vundle.vim
fi

if isWindows; then
    cmd //c mklink //d "%USERPROFILE%\\vimfiles" "%cd%\\vim"
else
    link vim
fi

link vimrc
vim +BundleInstall! +qall

echo "init postgres"
link psqlrc

echo "init nvim"
pip2 install pynvim neovim --upgrade --user --no-cache-dir
pip3 install pynvim neovim --upgrade --user --no-cache-dir
nvim +UpdateRemotePlugins +qall

source ~/.bash_profile
