# ~/.bashrc - Portable config for macOS and Linux

[[ $- != *i* ]] && return

# --- OS Detection ---
case "$(uname -s)" in
    Darwin) OS=macos; [[ "$(uname -m)" == "arm64" ]] && BREW_PREFIX=/opt/homebrew || BREW_PREFIX=/usr/local ;;
    Linux)  OS=linux ;;
esac

# --- History ---
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T "
shopt -s histappend cmdhist

# --- Shell Options ---
shopt -s checkwinsize cdspell extglob
shopt -s globstar 2>/dev/null

# --- Path ---
pathprepend() { [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; }
pathprepend "$HOME/.local/bin"
pathprepend "$HOME/bin"
[[ "$OS" == "macos" ]] && eval "$($BREW_PREFIX/bin/brew shellenv 2>/dev/null)"

export CDPATH=".:$HOME:$HOME/dev"

# --- Editor ---
export EDITOR=nvim VISUAL=nvim PAGER=less
export LESS='-RFXi'

# --- Languages ---

# Python (uv)
command -v uv &>/dev/null && eval "$(uv generate-shell-completion bash 2>/dev/null)"
alias py=python3
alias pip='uv pip'
alias venv='source .venv/bin/activate'
alias mkvenv='uv venv && venv'

# Node (nvm)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# Clojure / Java
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && . "$SDKMAN_DIR/bin/sdkman-init.sh"
[[ "$OS" == "macos" && -z "$JAVA_HOME" && -x /usr/libexec/java_home ]] && \
    export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)

# PostgreSQL (macOS Homebrew)
if [[ "$OS" == "macos" ]]; then
    for v in 17 16 15 14; do
        [[ -d "$BREW_PREFIX/opt/postgresql@$v/bin" ]] && {
            pathprepend "$BREW_PREFIX/opt/postgresql@$v/bin"
            export PGDATA="$BREW_PREFIX/var/postgresql@$v"
            break
        }
    done
fi

# Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Claude Code
pathprepend "$HOME/.claude/bin"

# --- Aliases ---

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Files
[[ "$OS" == "macos" ]] && alias ls='ls -G' || alias ls='ls --color=auto'
alias l='ls -lah'
alias ll='ls -lh'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Tools
alias v=nvim
alias vim=nvim
alias tm=tmux
alias tma='tmux attach -t'
alias g=git
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline -20'
alias gp='git push'
alias gpl='git pull'
alias gs='git status -sb'
alias gco='git checkout'
alias gb='git branch'
alias pg=psql
alias cc=claude

# Clipboard (works locally and over SSH via OSC 52)
if [[ "$OS" == "macos" ]]; then
    alias clip=pbcopy
    alias paste=pbpaste
elif [[ -n "$DISPLAY" ]] && command -v xclip &>/dev/null; then
    alias clip='xclip -selection clipboard'
    alias paste='xclip -selection clipboard -o'
else
    clip() { printf '\e]52;c;%s\a' "$(base64 | tr -d '\n')"; }
fi

# --- Functions ---

mkcd() { mkdir -p "$1" && cd "$1"; }
serve() { python3 -m http.server "${1:-8000}"; }

extract() {
    [[ -f "$1" ]] || { echo "Not a file: $1"; return 1; }
    case "$1" in
        *.tar.gz|*.tgz)  tar xzf "$1" ;;
        *.tar.bz2|*.tbz) tar xjf "$1" ;;
        *.tar.xz)        tar xJf "$1" ;;
        *.tar)           tar xf "$1" ;;
        *.zip)           unzip "$1" ;;
        *.gz)            gunzip "$1" ;;
        *.bz2)           bunzip2 "$1" ;;
        *.7z)            7z x "$1" ;;
        *)               echo "Unknown format: $1" ;;
    esac
}

# --- fzf ---
if command -v fzf &>/dev/null; then
    command -v fd &>/dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    [[ -f ~/.fzf.bash ]] && . ~/.fzf.bash
    [[ "$OS" == "macos" && -f "$BREW_PREFIX/opt/fzf/shell/key-bindings.bash" ]] && \
        . "$BREW_PREFIX/opt/fzf/shell/key-bindings.bash"
    [[ "$OS" == "linux" && -f /usr/share/doc/fzf/examples/key-bindings.bash ]] && \
        . /usr/share/doc/fzf/examples/key-bindings.bash
fi

# --- Prompt ---
# Style: [exit_status] user@host workdir [git_branch git_status]
#        HH:MM $

__prompt_command() {
    local exit_code=$?
    local red='\[\e[0;31m\]'
    local green='\[\e[0;32m\]'
    local yellow='\[\e[0;33m\]'
    local blue='\[\e[0;34m\]'
    local cyan='\[\e[0;36m\]'
    local reset='\[\e[0m\]'
    
    # Exit status indicator
    local indicator
    if [[ $exit_code -eq 0 ]]; then
        indicator="${green}✓${reset}"
    else
        indicator="${red}✗${reset}"
    fi
    
    # Git info
    local git_info=""
    if git rev-parse --git-dir &>/dev/null; then
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
        local status=""
        
        # Check for changes
        git diff --quiet 2>/dev/null || status+="*"
        git diff --cached --quiet 2>/dev/null || status+="+"
        [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]] && status+="?"
        
        git_info=" ${cyan}(${branch}${status})${reset}"
    fi
    
    PS1="${indicator} \u@\h ${yellow}\w${reset}${git_info}\n${reset}\$(date +%H:%M) \$ "
}

PROMPT_COMMAND="__prompt_command; history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# --- Completions ---
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
[[ "$OS" == "macos" && -r "$BREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && \
    . "$BREW_PREFIX/etc/profile.d/bash_completion.sh"

# --- Local overrides ---
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local
