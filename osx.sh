#!/bin/sh

set -e

# From http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac

# Check for Homebrew,
# Install if we don't have it
if ! type brew >/dev/null; then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

binaries=(
  openssl
  graphicsmagick
  python
  python3
  trash
  node
  tree
  ack
  hub
  git
  vim
  tmux
  neovim/neovim/neovim
)

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup

brew install caskroom/cask/brew-cask

# Apps
apps=(
  keepassx
  osxfuse
  dropbox
  google-chrome
  qlcolorcode
  screenflick
  slack
  filezilla
  appcleaner
  firefox
  qlmarkdown
  seil
  vagrant
  flash
  iterm2
  qlprettypatch
  virtualbox
  qlstephen
  vlc
  nvalt
  quicklook-json
  skype
  sourcetree
  chefdk
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask uninstall --force ${app[0]} && brew cask install --appdir="/Applications" ${apps[@]}

sudo pip install neovim
sudo pip3 install neovim
