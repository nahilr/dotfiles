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
    echo ""
}

# Copy with progress bar
cpp() {
    if command -v rsync >/dev/null 2>&1; then
        rsync -ah --info=progress2 "$1" "$2"
    else
        cp -iv "$1" "$2"
    fi
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
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	if [ "$cwd" != "$PWD" ] && [ -d "$cwd" ]; then
		builtin cd -- "$cwd"
		command zoxide add "$cwd"  # Feeds the path to zoxide
	else
		builtin true
	fi
	command rm -f -- "$tmp"
}

function md() {
  local name=$(basename "$1") 
  pandoc "$1" > "/tmp/$name.html"
  xdg-open "/tmp/$name.html"
}

##########################################
# Aliases
##########################################

unalias which 2>/dev/null
    
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
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

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
