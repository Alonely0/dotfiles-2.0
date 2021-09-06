# Setup fzf
# ---------
if [[ ! "$PATH" == */home/guillem/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/guillem/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/guillem/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/guillem/.fzf/shell/key-bindings.zsh"
