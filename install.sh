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
        for pkg in neovim tmux fzf ripgrep fd shellcheck shfmt bash-git-prompt; do
            brew list "$pkg" &>/dev/null || brew install "$pkg"
        done
        for cask in ghostty font-jetbrains-mono; do
            brew list --cask "$cask" &>/dev/null || brew install --cask "$cask"
        done
    elif [[ "$OS" == "linux" ]] && has apt-get; then
        sudo apt-get update -qq
        grep -q "neovim-ppa" /etc/apt/sources.list.d/* 2>/dev/null || { sudo add-apt-repository -y ppa:neovim-ppa/unstable; sudo apt-get update -qq; }
        for pkg in neovim tmux fzf ripgrep fd-find xclip shellcheck shfmt fonts-jetbrains-mono; do
            dpkg -s "$pkg" &>/dev/null || sudo apt-get install -y "$pkg"
        done
        if has flatpak; then
            flatpak info com.mitchellh.ghostty &>/dev/null || flatpak install -y flathub com.mitchellh.ghostty
        else
            warn "Ghostty not installed: install flatpak first, then run: flatpak install flathub com.mitchellh.ghostty"
        fi
    fi

    has uv || curl -LsSf https://astral.sh/uv/install.sh | sh

    export NVM_DIR="$HOME/.nvm"
    [[ -d "$NVM_DIR" ]] || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

    if [[ "$OS" == "linux" && ! -d "$HOME/.bash-git-prompt" ]]; then
        git clone --depth 1 https://github.com/magicmonty/bash-git-prompt.git "$HOME/.bash-git-prompt"
    fi

    has claude || { log "Installing Claude Code..."; curl -fsSL https://claude.ai/install.sh | bash; }
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
    link "$DOTFILES/ghostty/config" ~/.config/ghostty/config

    if [[ ! -f "$HOME/.gitconfig.local" ]]; then
        cp "$DOTFILES/gitconfig.local" "$HOME/.gitconfig.local"
        warn "Created ~/.gitconfig.local — edit it to set your name and email"
    else
        ok "~/.gitconfig.local already exists, skipping"
    fi

    mkdir -p ~/bin
    for f in "$DOTFILES/bin/"*; do [[ -f "$f" ]] && link "$f" ~/bin/"$(basename "$f")"; done
    chmod +x ~/bin/* 2>/dev/null || true
}

setup() {
    mkdir -p ~/.local/share/nvim/undo
    has nvim && { log "Installing nvim plugins..."; nvim --headless "+Lazy! sync" +qa 2>/dev/null || true; }
    [[ -d ~/.tmux/plugins/tpm ]] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    # Install Go development tools if Go is available
    if has go; then
        install_go_tools
    else
        warn "Go not found. Go development tools skipped."
        warn "Install Go and re-run this script to get Go tooling."
    fi
}

install_go_tools() {
    log "Installing Go development tools..."

    # Core debugging
    go install github.com/go-delve/delve/cmd/dlv@latest && ok "delve debugger"

    # Enhanced formatting (gofumpt)
    go install mvdan.cc/gofumpt@latest && ok "gofumpt"

    # Struct tag management
    go install github.com/fatih/gomodifytags@latest && ok "gomodifytags"

    # Test generation
    go install github.com/cweill/gotests/gotests@latest && ok "gotests"

    # Comprehensive linting
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest && ok "golangci-lint"

    # Vulnerability scanning
    go install golang.org/x/vuln/cmd/govulncheck@latest && ok "govulncheck"

    # Import management
    go install golang.org/x/tools/cmd/goimports@latest && ok "goimports"

    # Code generation helpers
    go install github.com/josharian/impl@latest && ok "impl"

    log "Go tools installation complete"
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
