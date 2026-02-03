# Dotfiles

Cross-platform dotfiles for macOS and Linux. Solarized Light theme.

## Install

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

To backup existing configs first: `./cleanup.sh` then `./install.sh`

## What's included

| File | Purpose |
|------|---------|
| `.bashrc` | Shell config with aliases for git, python, node, postgres |
| `.tmux.conf` | tmux with vim-style navigation, Solarized theme |
| `nvim/init.lua` | Neovim with LSP (Python, JS, Clojure, Bash), Telescope, Treesitter |
| `.gitconfig` | Git defaults (edit name/email after install) |
| `.psqlrc` | PostgreSQL client settings |
| `config/starship.toml` | Cross-shell prompt |

## Key bindings

**Neovim** (leader = space):
- `<leader>ff` find files, `<leader>fg` grep, `<leader>fb` buffers
- `<leader>e` file tree, `<leader>w` save, `<leader>q` quit
- `gd` definition, `gr` references, `K` hover, `<leader>ca` code action
- `<C-\>` terminal

**tmux** (prefix = C-b):
- `|` split vertical, `-` split horizontal
- `C-h/j/k/l` navigate panes (works with vim)
- `prefix + r` reload config

## Clipboard

Works locally and over SSH (via OSC 52). Requires terminal support:
- ✓ iTerm2, Alacritty, Kitty, WezTerm
- ✗ Terminal.app

## Post-install

1. Edit `~/.gitconfig` with your name/email
2. Restart shell: `source ~/.bashrc`
3. Open nvim - plugins auto-install
4. In tmux, press `prefix + I` to install plugins (optional)

## Local overrides

Machine-specific settings go in `~/.bashrc.local`
