# =========================================================
# Plugins — git + source, no manager
# =========================================================

export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZPLUGINDIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
ZCOMPLETIONS="${ZPLUGINDIR:h}/completions"
OMZDIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/omz"
mkdir -p "$ZPLUGINDIR" "$ZCOMPLETIONS" "$ZSH_CACHE_DIR/completions"
autoload -Uz is-at-least

_zplugin_load() {
  local plugin_path="${ZPLUGINDIR}/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    echo "Installing ${2}..." >&2
    git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
      || { echo "ERROR: failed to install ${2}" >&2; return 1; }
  fi
  if [[ -f "${plugin_path}/${2}.plugin.zsh" ]]; then
    source "${plugin_path}/${2}.plugin.zsh"
  else
    local -a found=("${plugin_path}"/*.plugin.zsh(N))
    (( $#found )) && source "$found[1]" \
      || { echo "ERROR: no .plugin.zsh in $plugin_path" >&2; return 1; }
  fi
}

_zplugin_omz() {
  local name=$1 kind=${2:-plugin} file
  if [[ ! -d "$OMZDIR" ]]; then
    echo "Installing oh-my-zsh (shallow)..." >&2
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh "$OMZDIR" \
      || { echo "ERROR: failed to clone ohmyzsh" >&2; return 1; }
  fi
  ZSH="$OMZDIR"
  if [[ $kind == lib ]]; then
    file="$OMZDIR/lib/$name.zsh"
  else
    file="$OMZDIR/plugins/$name/$name.plugin.zsh"
  fi
  [[ -f $file ]] || { echo "ERROR: missing $file" >&2; return 1; }
  source "$file"
}

zplugin-update() {
  local dir
  for dir in "$ZPLUGINDIR"/*(N/) "$OMZDIR"; do
    [[ -d "$dir/.git" ]] || continue
    echo "Updating ${dir:t}..."
    git -C "$dir" pull --ff-only --quiet || echo "FAILED: ${dir:t}" >&2
  done
}

# --- completions first: fpath, then compinit ---------------------
_zplugin_load zsh-users zsh-completions
fpath=("$ZCOMPLETIONS" "$ZSH_CACHE_DIR/completions" $fpath)
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcompdump"

# --- plugins ------------------------------------------------------
_zplugin_load zsh-users zsh-autosuggestions
_zplugin_load zsh-users zsh-history-substring-search

# --- oh-my-zsh pieces ---------------------------------------------
_zplugin_omz git lib        # git_current_branch, needed by the aliases below
_zplugin_omz git
_zplugin_omz sudo
_zplugin_omz command-not-found
_zplugin_omz aws
_zplugin_omz docker

# --- completion UI, then highlighting last ------------------------
_zplugin_load Aloxaf fzf-tab
_zplugin_load zdharma-continuum fast-syntax-highlighting