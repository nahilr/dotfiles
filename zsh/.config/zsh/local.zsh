# fnm
FNM_PATH="/home/neo/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Android Studio Paths
export ANDROID_HOME="/mnt/Work/Android/Sdk"
export ANDROID_USER_HOME="/mnt/Work/Android/.android"
export ANDROID_AVD_HOME="/mnt/Work/Android/.android/avd"
export GRADLE_USER_HOME="/mnt/Work/Android/.gradle"

typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.bun/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.opencode/bin"
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/build-tools/36.0.0"
    "$HOME/.foundry/bin"
    $path
)
export PATH

export T3CODE_TELEMETRY_ENABLED=false
