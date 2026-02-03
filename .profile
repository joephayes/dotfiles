# ~/.profile - POSIX fallback, sources .bashrc if running bash

export LANG="${LANG:-en_US.UTF-8}"
export EDITOR=nvim

[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# Source .bashrc if running bash interactively
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
