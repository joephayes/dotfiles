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
| `.bashrc` | Shell config with git-aware prompt, aliases for git, python, node, postgres |
| `.tmux.conf` | tmux with vim-style navigation, Solarized theme |
| `nvim/init.lua` | Neovim 0.11+ with native LSP, Telescope, Treesitter |
| `.gitconfig` | Git defaults (edit name/email after install) |
| `.psqlrc` | PostgreSQL client settings |

## Language Support

**Python** - LSP via pyright, managed with uv:
- `mkvenv` - create .venv and activate
- `venv` - activate existing .venv
- `uvr` - uv run, `uvs` - uv sync, `uva` - uv add
- `uvpy` - uv python (install/manage Python versions)

**Node.js** - LSP via ts_ls, managed with nvm:
- `nvm install --lts` - install latest LTS
- `nvm use <version>` - switch versions

**Clojure** - LSP via clojure_lsp, REPL via Conjure:
- `,ee` - eval expression, `,eb` - eval buffer
- `,lv` - show log buffer

**Bash** - LSP via bashls, linting via shellcheck, formatting via shfmt:
- `<leader>lf` - format buffer
- Shellcheck diagnostics appear inline
- 4-space indentation by default

**SQL** - LSP via sqls, syntax via treesitter

## Key bindings

**Neovim** (leader = space):
- `<leader>ff` find files, `<leader>fg` grep, `<leader>fb` buffers
- `<leader>e` file tree, `<leader>w` save, `<leader>q` quit
- `gd` definition, `gr` references, `K` hover, `<leader>ca` code action
- `<leader>g` git (neogit), `<C-\>` terminal, `<leader>cc` Claude Code

**tmux** (prefix = C-b):
- `|` split vertical, `-` split horizontal
- `C-h/j/k/l` navigate panes (works with vim)
- `prefix + r` reload config
- `prefix + I` install TPM plugins (run once after install)

## Clipboard

Works locally and over SSH (via OSC 52). Requires terminal support:
- ✓ iTerm2, Alacritty, Kitty, WezTerm
- ✗ Terminal.app

## Post-install

1. Edit `~/.gitconfig` with your name/email
2. Restart shell: `source ~/.bashrc`
3. Open nvim - plugins auto-install
4. In tmux: `prefix + I` to install TPM plugins
5. VS Code: "Solarized Light" is built-in. If not working, run `Preferences: Color Theme` and select it.

## Local overrides

Machine-specific settings go in `~/.bashrc.local`
