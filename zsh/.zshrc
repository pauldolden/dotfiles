# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source aliases early to ensure they are available
source ~/.config/zsh/aliases.zsh

# Lazy load nvm
export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() {
  unset -f nvm node npm
  lazy_load_nvm
  nvm "$@"
}

# Source plugins
source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-syntax-highlighting/theme.zsh

# Set up completion
autoload -Uz compinit
# Use a cached zcompdump file to speed up compinit
if [[ -f ~/.zcompdump ]]; then
  compinit -C -d ~/.zcompdump
else
  compinit -C
fi

# Auto-start tmux if not already inside a tmux session
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# Update tmux pane title
function update_tmux_pane_title() {
    if [[ -n "$TMUX" ]]; then
        tmux rename-window "${PWD:t}"
    fi
}
precmd_functions+=update_tmux_pane_title

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# Initialize Atuin
eval "$(atuin init zsh)"

# pnpm configuration
export PNPM_HOME="/Users/PDolden/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Set FZF options
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
