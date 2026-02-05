#!/usr/bin/env bash
# Link VS Code settings and install extensions
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { echo "==> $*"; }
ok()   { echo "  ✓ $*"; }
warn() { echo "  ! $*" >&2; }

link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]] && { ok "$dst"; return; }
    [[ -e "$dst" || -L "$dst" ]] && { mv "$dst" "${dst}.bak.$(date +%s)"; warn "Backed up: $dst"; }
    ln -sf "$src" "$dst" && ok "$dst"
}

# Platform-specific VS Code User directory
case "$(uname -s)" in
    Darwin) vscode="$HOME/Library/Application Support/Code/User" ;;
    Linux)  vscode="$HOME/.config/Code/User" ;;
    *)      echo "Unsupported OS"; exit 1 ;;
esac

log "Symlinking settings..."
link "$DOTFILES/vscode/settings.json" "$vscode/settings.json"
link "$DOTFILES/vscode/keybindings.json" "$vscode/keybindings.json"

log "Installing extensions..."
if command -v code &>/dev/null; then
    grep -v '^#' "$DOTFILES/vscode/extensions.txt" | grep -v '^$' | xargs -L 1 code --install-extension
else
    warn "'code' not on PATH. Add it via VS Code: Command Palette > Shell Command: Install 'code' command in PATH"
    warn "Then re-run: $0"
fi

log "Done"
