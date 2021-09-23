#!/bin/sh

set -e

# From http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac

# Check for Homebrew,
# Install if we don't have it
if ! type brew >/dev/null; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install GNU 'ftp', 'telnet', etc.
brew install inetutils

# Install Bash 5
brew install bash

# Install latest Java (required by Clojure)
brew tap homebrew/cask
brew install java
sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

binaries=(
  wget
  grep
  clojure
  openssl
  graphicsmagick
  python
  trash
  node
  tree
  ack
  hub
  git
  vim
  tmux
  neovim
  bash-completion
  bash-git-prompt
  reattach-to-user-namespace
  the_silver_searcher
  go
  gpg
  pinentry-mac
  daemontools
  rust
  jq
  )

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup

echo "initialize GPG"
mkdir -p ~/.gnupg
echo 'pinentry-program /usr/local/bin/pinentry-mac' >> ~/.gnupg/gpg-agent.conf

# Install tap for fonts
brew tap homebrew/cask-fonts

# Apps
apps=(
  eclipse-jee
  qlimagesize
  google-chrome
  appcleaner
  firefox
  qlmarkdown
  iterm2
  qlprettypatch
  vlc
  quicklook-csv
  quicklook-json
  sourcetree
  font-inconsolata
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
brew install ${apps[@]} || true
