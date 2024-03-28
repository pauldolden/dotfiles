# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
# DISABLE_AUTO_TITLE="true"
# precmd () { print -Pn "\e]0;${PWD##*/}\a" }
eval "$(starship init zsh)"

function update_tmux_pane_title() {
    if [[ -n "$TMUX" ]]; then
        tmux rename-window "${PWD:t}"
    fi
}

# For every command execution, update pane title
precmd_functions+=update_tmux_pane_title

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/pauldolden/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/pauldolden/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/pauldolden/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/pauldolden/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(atuin init zsh)"


[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"
