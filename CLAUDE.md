# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A cross-platform dotfiles repository for macOS (Intel/Apple Silicon) and Linux. All config files are symlinked into place by `install.sh`. The consistent theme across all editors and the shell is Solarized Light.

## Languages supported

- Python (pyright LSP, ruff linting, uv for venvs/packages)
- Node.js/JS/TS (ts_ls LSP, nvm for versions)
- Go (gopls LSP, delve debugging, gofumpt formatting, golangci-lint)
- Clojure (clojure_lsp, Conjure REPL)
- SQL (sqls LSP, treesitter)
- Bash (bashls LSP, shellcheck linting, shfmt formatting)

## Installation and setup

```bash
./install.sh            # Full install: deps + symlinks + plugin bootstrap
./install.sh --skip-deps  # Symlinks and plugin setup only
./cleanup.sh            # Backup existing configs before a fresh install
./cleanup.sh -c         # Also clear nvim/tmux plugin caches
```

LSP servers are auto-installed by mason-lspconfig on first launch (`pyright`, `ruff`, `ts_ls`, `clojure_lsp`, `bashls`, `sqls`, `lua_ls`, `gopls`).

tmux plugins require a one-time `prefix + I` (TPM install) after first launch.

### Post-install steps

1. `./install.sh`
2. Edit `~/.gitconfig` name/email
3. `source ~/.bashrc`
4. Open nvim — LSPs install automatically via mason-lspconfig on first launch
5. tmux: `prefix + I` for TPM plugins
6. For Go: Install Go first, then re-run `./install.sh` to get Go development tools automatically

## Repository structure

| Path | Role |
|------|------|
| `.bashrc` | Main shell config. Sources `.bashrc.local` at the end for per-machine overrides. |
| `.bash_profile` | Login shell entry — inits Homebrew, sources `.bashrc`. |
| `.tmux.conf` | tmux config with vim-style nav and vim-tmux-navigator integration. |
| `nvim/init.lua` | Single-file Neovim config. Lazy.nvim plugin manager, native 0.11+ LSP, gitsigns + neogit for git, comprehensive Go support with debugging. |
| `vscode/` | Settings and keybindings (symlinked by `vscode-setup.sh`). Extensions list in `extensions.txt`. |
| `bin/git-nice` | Checkout default branch, pull, then run `git-branch-scrub`. Invoked as `git nice`. |
| `bin/git-branch-scrub` | Prune remote refs, then delete all local branches merged into the default branch. Invoked as `git branch-scrub`. |
| `.gitconfig` | Git config with rebase-first pull, auto-setup remotes, SSH-over-HTTPS for GitHub. |
| `.psqlrc` | psql prompt, per-database history, saved queries for common ops (locks, table sizes). |
| `ghostty/config` | Ghostty terminal config: Solarized Light theme, JetBrains Mono, xterm-256color for remote compat. |
| `install.sh` | Idempotent installer: detects OS, installs deps via Homebrew or apt, creates symlinks, bootstraps plugins. |
| `cleanup.sh` | Backs up existing dotfiles to a timestamped directory before install. |

## Shell conventions in .bashrc

- OS is detected once at the top into `$OS` (`macos` or `linux`) and `$BREW_PREFIX`. Use these rather than re-detecting.
- `pathprepend()` is the helper for adding to PATH without duplicates.
- Language tool chains are each in their own labeled section: Python/uv, Node/nvm, Clojure/SDKMAN, PostgreSQL, Rust.
- Machine-specific config goes in `~/.bashrc.local` — never in `.bashrc` itself.

## Neovim layout (nvim/init.lua)

Single file, top-to-bottom:
1. Options block
2. Lazy.nvim bootstrap
3. Plugin table (colorscheme first with `priority = 1000`, then status line, file tree, telescope, treesitter, mason, completion, git, editing helpers, conjure, tmux nav, toggleterm, go.nvim, neotest, nvim-dap)
4. LSP setup using `vim.lsp.config` (native 0.11+ API) — pyright, ts_ls, clojure_lsp, bashls, sqls, lua_ls, gopls
5. Global keymaps
6. Filetype autocmds (2-space for JS/TS/JSON/YAML/HTML/CSS/Clojure; 4-space for bash; tabs for Go)
7. Format keymap and yank highlight
8. OSC 52 clipboard for SSH

Leader is `<Space>`, local leader is `,` (used by Conjure for Clojure).

### Key keybindings

| Key | Action |
|-----|--------|
| `<leader>cc` | Claude Code (tmux split, `C-h` to return to nvim) |
| `<leader>cx` | Claude with current file (`@file` reference) |
| `<leader>cs` | Claude with visual selection (writes to tempfile) |
| `Ctrl+B Ctrl+C` | Claude Code from anywhere in tmux |
| `<leader>lf` | Format buffer |
| `<leader>ff/fg/fb` | Telescope find files/grep/buffers |
| `gd/gr/K` | Definition/references/hover |
| `<leader>g*` | Go tools (tags, imports, tests, coverage) |
| `<leader>t*` | Testing (run, debug, nearest) |
| `F5/F10/F11/F12` | Debugging (continue, step over/into/out) |

## Indentation rules

| Filetype | Indent |
|----------|--------|
| Bash/sh | 4 spaces |
| Python | 4 spaces |
| Go | tabs (4-space width) |
| JS, TS, JSON, YAML, HTML, CSS, Clojure | 2 spaces |

## Git workflow helpers

`bin/git-nice` and `bin/git-branch-scrub` are designed to live in `~/bin` (which is on PATH) so git discovers them as subcommands (`git nice`, `git branch-scrub`). They auto-detect the default branch by checking `origin/HEAD`, falling back to `main` then `master`.

## Clipboard over SSH

Both the shell and Neovim fall back to OSC 52 sequences when running over SSH. This works in Ghostty, iTerm2, Alacritty, Kitty, and WezTerm but not in macOS Terminal.app.

## What install.sh symlinks

Every managed file is a symlink back into this repo. If you add a new config file here, add a corresponding `link` call in `install_symlinks()` in `install.sh`, and a `backup` call in `cleanup.sh`.

## Known decisions

- No starship — using bash-git-prompt (magicmonty) with Solarized theme
- `uv` preferred over `pip`/`venv` for Python
- `nvm` for Node version management
- Neovim 0.11+ required (uses native `vim.lsp.config` API)
- TPM for tmux plugins (`prefix + I` to install)
