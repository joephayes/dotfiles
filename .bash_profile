# ~/.bash_profile - Login shell sources .bashrc

export LANG="${LANG:-en_US.UTF-8}"

# macOS Homebrew
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -f /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"

# Source .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc
