# Dotfiles

Cross-platform dotfiles for macOS (Intel/Apple Silicon) and Linux. Solarized Light theme everywhere.

## Install

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./cleanup.sh      # backup existing configs first (optional)
./install.sh      # deps + symlinks + plugin bootstrap
```

`./install.sh --skip-deps` to skip dependency installation.

## What's included

| File | Purpose |
|------|---------|
| `.bashrc` | Shell config with bash-git-prompt, aliases for git, python, node, postgres |
| `ghostty/config` | Ghostty terminal (Solarized Light, JetBrains Mono) |
| `nvim/init.lua` | Neovim 0.11+ with native LSP, Telescope, Treesitter, Go debugging |
| `.gitconfig` | Git defaults — identity loaded from `~/.gitconfig.local` (created on install) |
| `.psqlrc` | PostgreSQL client settings |
| `vscode/` | VS Code settings, keybindings, extensions list |
| `bin/git-nice` | `git nice` — checkout default branch, pull, scrub merged branches |
| `bin/git-branch-scrub` | `git branch-scrub` — prune remotes, delete merged local branches |

## Language support

| Language | LSP | Tooling |
|----------|-----|---------|
| Python | pyright, ruff | uv |
| Node.js/TS | ts_ls | nvm |
| Go | gopls | delve, gofumpt, golangci-lint |
| Clojure | clojure_lsp | Conjure REPL |
| SQL | sqls | treesitter |
| Bash | bashls | shellcheck, shfmt |

LSP servers auto-install via mason-lspconfig on first Neovim launch.

## Key bindings

**Neovim** (leader = space):
- `<leader>ff/fg/fb` — find files / grep / buffers
- `<leader>e` file tree, `<leader>g` git (neogit), `<leader>cc` Claude Code
- `<leader>lf` format buffer
- `gd` definition, `gr` references, `K` hover, `<leader>ca` code action
- **Go**: `<leader>g*` Go tools, `<leader>t*` testing, `F5/F10/F11/F12` debugging

**herdr** (prefix = C-b; installed by `install.sh`):
- `C-h/j/k/l` navigate between nvim windows and herdr panes
- `<leader>cc/cx/cs` open or reuse a Claude Code pane next to nvim

## Post-install

1. Edit `~/.gitconfig.local` with your name/email (created automatically by `install.sh`)
2. `source ~/.bashrc`
3. Open nvim — LSPs install automatically
4. VS Code (optional): `./vscode-setup.sh`
5. For Go: Install Go first, then re-run `./install.sh` to get Go development tools

## Local overrides

Machine-specific config goes in `~/.bashrc.local` — never edit `.bashrc` directly.

## Clipboard over SSH

OSC 52 sequences work in Ghostty, iTerm2, Alacritty, Kitty, and WezTerm. Not supported in Terminal.app.
