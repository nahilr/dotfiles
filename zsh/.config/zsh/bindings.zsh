# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey ' ' magic-space                           # do history expansion on space
# History substring search provided by plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

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
