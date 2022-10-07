#!/usr/bin/env bash

set -ex

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

if [ ! -d ~/.tmux/plugins/tpm ]; then
      run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'

      run '~/.tmux/plugins/tpm/tpm'
fi

echo "init vim ..."
if isWindows; then
    cmd //c mklink //d "%USERPROFILE%\\vimfiles" "%cd%\\vim"
else
    link vim
fi
link vimrc

echo "init nvim..."
mkdir -p ~/.config/nvim/
ln -s "`$pwd`/init.vim" ~/.config/nvim/init.vim

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "init postgres"
link psqlrc

mkdir ~/bin
ln -s "`$pwd`/git-nice" ~/bin/git-nice
ln -s "`$pwd`/git-branch-scrub" ~/bin/git-branch-scrub
ln -s "`$pwd`/vim-update-plugins.sh" ~/bin/vim-update-plugins.sh

source ~/.bash_profile
