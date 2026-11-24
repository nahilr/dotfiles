# For benchmarking (Uncomment below line and last line)
# zmodload zsh/zprof

# Environment
# =========================================================

# If 'fresh' is installed
if command -v fresh >/dev/null 2>&1; then
  export EDITOR=fresh
else
  export EDITOR=nano
fi

# Set VISUAL to be the same as EDITOR
export VISUAL="$EDITOR"

export TERM=xterm-256color

if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
  export MANPAGER="batcat -l man -p"
fi

# Shell Configs
# =========================================================

# History Settings
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000

setopt sharehistory          # Share history across shells (implies appendhistory & inc_append_history)
setopt hist_ignore_space     # Don't record commands starting with a space
setopt hist_ignore_all_dups  # Delete old duplicate entry if new one is typed
setopt hist_find_no_dups     # Do not display duplicates when searching history

# Completion & Globbing
setopt extendedglob          # Advanced pattern matching (#, ~, ^)
setopt globdots              # Include dotfiles in globbing
setopt autocd                # Auto cd when typing a directory path
setopt auto_param_slash      # Add trailing slash on directory parameter completion
setopt nocaseglob            # Case-insensitive matching
setopt numeric_glob_sort     # Logical numeric sorting

# Terminal & Shell Options
setopt interactive_comments       # Allow inline comments (#) in interactive shell
[[ -t 0 ]] && stty stop undef     # Disable Ctrl+S terminal freeze

if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
  export LS_COLORS="${LS_COLORS}:ow=30;44:"   # world-writable dirs
fi

# Modular Config Files
# =========================================================

# Aliases
source "$ZDOTDIR/aliases.zsh"

# Plugins and plugin manager
source "$ZDOTDIR/plugins.zsh"

# Custom keybindings
source "$ZDOTDIR/bindings.zsh"

# User Custom Configurations
if [[ -f "$ZDOTDIR/local.zsh" ]]; then
  source "$ZDOTDIR/local.zsh"
fi

# Completions and Styling
# =========================================================

zstyle ':completion:*' menu no
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*:*:kill:*:processes' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always --group-directories-first $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons=always --group-directories-first $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -f $realpath ]] && bat --color=always --style=numbers --line-range=:60 $realpath'
zstyle ':fzf-tab:*' query-string input

# LOAD COMPLETIONS
# autoload -Uz compinit
# compinit -d ~/.cache/zcompdump

# Shell integrations
# =========================================================

source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

[[ -o interactive && $SHLVL -eq 1 ]] && [[ -x /usr/bin/fastfetch ]] && fastfetch

# zprof
