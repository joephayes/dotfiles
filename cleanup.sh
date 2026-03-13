#!/usr/bin/env bash
#
# Backup existing dotfiles before installing new ones.
# Backups go to ~/dotfiles_backup_YYYYMMDD_HHMMSS/
#
set -euo pipefail

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
INCLUDE_CACHES=false

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    -y, --yes             Skip confirmation
    -c, --include-caches  Also remove Neovim/tmux plugin caches
    -h, --help            Show this help
EOF
    exit 0
}

# Parse args
SKIP_CONFIRM=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes)             SKIP_CONFIRM=true ;;
        -c|--include-caches)  INCLUDE_CACHES=true ;;
        -h|--help)            usage ;;
        *)                    echo "Unknown option: $1" >&2; exit 1 ;;
    esac
    shift
done

# Confirm
if [[ "$SKIP_CONFIRM" == false ]]; then
    echo "Backup existing dotfiles to: $BACKUP_DIR"
    read -p "Continue? [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 0
fi

mkdir -p "$BACKUP_DIR"

# Backup file/dir if it exists
backup() {
    local src="$1"
    if [[ -e "$src" || -L "$src" ]]; then
        mv "$src" "$BACKUP_DIR/"
        echo "Backed up: $src"
    fi
}

# Remove without backup (for caches)
remove() {
    [[ -e "$1" ]] && rm -rf "$1" && echo "Removed: $1"
}

# Dotfiles
backup ~/.bashrc
backup ~/.bash_profile
backup ~/.profile
backup ~/.bashrc.local
backup ~/.tmux.conf
backup ~/.gitconfig
backup ~/.gitignore_global
backup ~/.psqlrc
backup ~/.config/nvim
backup ~/.config/ghostty

# VS Code (platform-specific path)
if [[ "$(uname)" == "Darwin" ]]; then
    vscode="$HOME/Library/Application Support/Code/User"
else
    vscode="$HOME/.config/Code/User"
fi
[[ -d "$vscode" ]] && backup "$vscode/settings.json" && backup "$vscode/keybindings.json"

# Bin scripts
backup ~/bin/git-branch-scrub
backup ~/bin/git-nice

# Optional: clear plugin caches
if [[ "$INCLUDE_CACHES" == true ]]; then
    remove ~/.tmux/plugins
    remove ~/.local/share/nvim
    remove ~/.local/state/nvim
    remove ~/.cache/nvim
fi

echo ""
echo "Done. Backups in: $BACKUP_DIR"
echo "To restore: cp -a $BACKUP_DIR/. ~/"
