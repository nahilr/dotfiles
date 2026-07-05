# For benchmarking (Uncomment below line and last line)
# zmodload zsh/zprof
#####################################
# Environment
#####################################

# If 'micro' is installed
if command -v micro >/dev/null 2>&1; then
  export EDITOR=micro
else
  export EDITOR=nano
fi

# Set VISUAL to be the same as EDITOR
export VISUAL="$EDITOR"

export TERM=xterm-256color

export BUN_INSTALL="$HOME/.bun"

typeset -U path
path=(
    "$HOME/.bun/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/.opencode/bin"
    $path
)
export PATH

# Source local environment file
if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi

# fnm
FNM_PATH="/home/neo/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

######################################
# ZINIT
######################################
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::aws
zinit snippet OMZP::bun
zinit snippet OMZP::fnm

#####################################
# Completions
#####################################
# Load completions styling
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# fzf-tab styling
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# bun completions
#[ -s "/home/neo/.bun/_bun" ] && source "/home/neo/.bun/_bun"
# fnm completions
#zinit ice as"completion" id-as"fnm-completion" has"fnm" nocompile \
#    atclone"fnm completions --shell zsh > _fnm" atpull"%atclone"
#zinit snippet /dev/null
# opencode completions
zinit ice as"completion" id-as"opencode-completion" has"opencode" nocompile \
    atclone"opencode completion > _opencode" atpull"%atclone"
zinit snippet /dev/null

# LOAD COMPLETIONS
# autoload -Uz compinit && compinit
# compinit -d ~/.cache/zcompdump

# Using zinit to load completions
zinit ice atinit"zicompinit; zicdreplay"

zinit light zsh-users/zsh-syntax-highlighting
zinit cdreplay -q

#####################################
# Shell Configs
#####################################
# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey ' ' magic-space                           # do history expansion on space

# deleted text is added to the kill ring (clipboard), which allows us to paste it later with Ctrl + Y
bindkey '^[w' kill-region						  # alt + w : Delete text between mark and cursor. 
bindkey '^U' backward-kill-line                   # ctrl + U : Deletes everything from the cursor back to the start of the line.
bindkey '^[[3;5~' kill-word                       # ctrl + del : Deletes the word immediately to the right of the cursor.
bindkey '^[[3~' delete-char                       # delete: Ensure standard Delete key behaviour
bindkey '^H' backward-kill-word                   # Ctrl + Backspace: Deletes the word to the left of the cursor

bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# History
HISTSIZE=10000
HISTFILE=~/.histfile
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt extendedglob
setopt globdots

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
fi

#####################################
# Functions
#####################################
# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip () {
    local default_iface
    default_iface=$(ip route show default | awk '/default/ {print $5}' | head -n 1)
    if [ -n "$default_iface" ]; then
        echo -n "Internal IP ($default_iface): "
        if command -v ip >/dev/null 2>&1; then
            ip -4 addr show dev "$default_iface" | awk '/inet/ {print $2}' | cut -d/ -f1
        elif command -v ifconfig >/dev/null 2>&1; then
            ifconfig "$default_iface" | awk '/inet / {print $2}'
        else
            echo "Networking tools (ip/ifconfig) not found."
        fi
    else
        echo "Internal IP: Not connected to a network."
    fi
    echo -n "External IP: "
    curl -s ifconfig.me
    echo "" # Prints a newline so your terminal prompt doesn't get messed up
}

# Copy file with a progress bar
cpp() {
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
		awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Extracts any archive(s) (if unp isn't installed)
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Create and go to the directory
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}

#yazi -> y shell wrapper that provides the ability to change the current working directory when exiting Yazi.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

##########################################
# Aliases
##########################################

# Smart ls/eza Aliases
if command -v eza >/dev/null 2>&1; then
    # eza is installed, use eza aliases
    alias ls='eza -F=always --icons=always'
    alias la='ls -a'                          # show hidden files
    alias l='ls -lgh'                         # long listing format
    alias ll='ls -lagh'                       # long listing with hidden files
    alias lss='ll -s size'                    # sort by size
    alias lsd='ll -s size --total-size'       # sort by size (eza only)
    alias lx='ll -s extension'                # sort by extension (eza only)
    alias lt='ll -lrs modified'               # sort by modified date
    alias lf="ll -f"                          # files only (eza only)
    alias ldir="ll -D"                        # directories only (eza only)
    alias lsg="ll --git --git-repos"          # git status (eza only)
else
    # eza is NOT installed, use standard ls aliases
    alias ls='ls --color=auto'
    alias la='ls -a'
    alias l='ls -lgh'
    alias ll='ls -lagh'
fi

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias multitail='multitail --no-repeat -c'


# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm --recursive --force --verbose'

# Search command line history
alias h="history 0 | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# Show open ports
alias openports='ss -tulnpa'

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'

alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

#lazy
alias lzg='lazygit'
alias lzd='lazydocker'

#tldr
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs -r tldr'

#warp
alias warpc='warp-cli -vv connect'
alias warpd='warp-cli -vv disconnect'
alias warps='warp-cli -vv status'

alias refreshwifidriver='sudo modprobe -r iwlmvm && sudo modprobe iwlmvm'

#############################################

if [ -f /usr/bin/fastfetch ]; then
	fastfetch
fi

# Shell integrations
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

# zprof
