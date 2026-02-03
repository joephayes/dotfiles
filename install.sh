#!/usr/bin/env bash
# Install dotfiles - creates symlinks and optionally installs dependencies
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { echo "==> $*"; }
ok()   { echo "  ✓ $*"; }
warn() { echo "  ! $*" >&2; }
has()  { command -v "$1" &>/dev/null; }

link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]] && { ok "$dst"; return; }
    [[ -e "$dst" || -L "$dst" ]] && { mv "$dst" "${dst}.bak.$(date +%s)"; warn "Backed up: $dst"; }
    ln -sf "$src" "$dst" && ok "$dst"
}

# OS detection
case "$(uname -s)" in
    Darwin) OS=macos ;;
    Linux)  OS=linux ;;
    *)      OS=unknown ;;
esac

install_deps() {
    log "Installing dependencies..."
    
    if [[ "$OS" == "macos" ]]; then
        has brew || { /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"; }
        for pkg in neovim tmux fzf ripgrep fd starship; do
            brew list "$pkg" &>/dev/null || brew install "$pkg"
        done
    elif [[ "$OS" == "linux" ]] && has apt-get; then
        sudo apt-get update -qq
        grep -q "neovim-ppa" /etc/apt/sources.list.d/* 2>/dev/null || { sudo add-apt-repository -y ppa:neovim-ppa/unstable; sudo apt-get update -qq; }
        for pkg in neovim tmux fzf ripgrep fd-find xclip; do
            dpkg -s "$pkg" &>/dev/null || sudo apt-get install -y "$pkg"
        done
        has starship || curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
    
    has uv || curl -LsSf https://astral.sh/uv/install.sh | sh
    
    export NVM_DIR="$HOME/.nvm"
    [[ -d "$NVM_DIR" ]] || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
}

install_symlinks() {
    log "Creating symlinks..."
    link "$DOTFILES/.bashrc" ~/.bashrc
    link "$DOTFILES/.bash_profile" ~/.bash_profile
    link "$DOTFILES/.profile" ~/.profile
    link "$DOTFILES/.tmux.conf" ~/.tmux.conf
    link "$DOTFILES/.gitconfig" ~/.gitconfig
    link "$DOTFILES/.gitignore_global" ~/.gitignore_global
    link "$DOTFILES/.psqlrc" ~/.psqlrc
    link "$DOTFILES/nvim/init.lua" ~/.config/nvim/init.lua
    link "$DOTFILES/config/starship.toml" ~/.config/starship.toml
    
    mkdir -p ~/bin
    for f in "$DOTFILES/bin/"*; do [[ -f "$f" ]] && link "$f" ~/bin/"$(basename "$f")"; done
    chmod +x ~/bin/* 2>/dev/null || true
}

setup() {
    mkdir -p ~/.local/share/nvim/undo
    has nvim && { log "Installing nvim plugins..."; nvim --headless "+Lazy! sync" +qa 2>/dev/null || true; }
    [[ -d ~/.tmux/plugins/tpm ]] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

# Main
skip_deps=false
[[ "${1:-}" == "--skip-deps" ]] && skip_deps=true
[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { echo "Usage: $0 [--skip-deps]"; exit 0; }

log "Detected: $OS"
[[ "$skip_deps" == false ]] && install_deps
install_symlinks
setup
log "Done! Run: source ~/.bashrc"
