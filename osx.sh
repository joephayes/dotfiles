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

binaries=(
  wget
  grep
  clojure
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
  neovim
  leiningen
  bash-completion
  bash-git-prompt
  reattach-to-user-namespace
  the_silver_searcher
  go
  gpg
  pinentry-mac
  daemontools
  )

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup

echo "initialize GPG"
mkdir -p ~/.gnupg
echo 'pinentry-program /usr/local/bin/pinentry-mac' >> ~/.gnupg/gpg-agent.conf

# Apps
apps=(
  java
  eclipse-jee
  keepassx
  qlimagesize
  dropbox
  google-hangouts
  google-backup-and-sync
  google-chrome
  qlcolorcode
  slack
  appcleaner
  firefox
  qlmarkdown
  vagrant
  iterm2
  qlprettypatch
  virtualbox
  qlstephen
  vlc
  nvalt
  quicklook-csv
  quicklook-json
  skype
  epubquicklook
  sourcetree
  xquartz
  visualvm
  gimp
  font-inconsolata
  visual-studio-code
)


# Install tap for fonts
brew tap caskroom/fonts

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
brew cask install ${apps[@]} || true

pip install neovim --upgrade --user
pip3 install neovim --upgrade --user
