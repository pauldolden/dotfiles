# Source configuration files
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/exports.zsh
source ~/.config/zsh/functions.zsh

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MAC=true
    BREW_PREFIX=$(brew --prefix 2>/dev/null || echo "/opt/homebrew")
else
    IS_MAC=false
fi

# zsh-vi-mode (macOS only via Homebrew)
if [[ "$IS_MAC" == true ]] && [[ -f "$BREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
    source "$BREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi

export COREPACK_ENABLE_AUTO_PIN=0

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
export PATH="$HOME/zig:$PATH"

# zsh-autocomplete
[[ -f ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]] && \
    source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# zsh-autosuggestions (Homebrew on Mac, local on Linux)
if [[ "$IS_MAC" == true ]] && [[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting (Homebrew on Mac, local on Linux)
if [[ "$IS_MAC" == true ]] && [[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Theme (if exists)
[[ -f ~/.config/zsh/zsh-syntax-highlighting/theme.zsh ]] && \
    source ~/.config/zsh/zsh-syntax-highlighting/theme.zsh

# Set up completion (optimized - only run dump once per day)
autoload -Uz compinit
setopt EXTENDEDGLOB
local zcompdump="$HOME/.zcompdump"
# Check if zcompdump is older than 24 hours
if [[ -n $zcompdump(#qNmh-24) ]]; then
  # Use cached version if less than 24 hours old
  compinit -C -d "$zcompdump"
else
  # Regenerate completion dump
  compinit -d "$zcompdump"
fi
unsetopt EXTENDEDGLOB

# Update tmux pane title
function update_tmux_pane_title() {
    if [[ -n "$TMUX" ]]; then
        tmux rename-window "${PWD:t}"
    fi
}
precmd_functions+=update_tmux_pane_title

# Lazy load Google Cloud SDK
lazy_load_gcloud() {
  if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
  fi
  if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
  fi
}

gcloud() {
  unset -f gcloud gsutil
  lazy_load_gcloud
  gcloud "$@"
}

gsutil() {
  unset -f gcloud gsutil
  lazy_load_gcloud
  gsutil "$@"
}

# Initialize Atuin (if installed)
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# pnpm configuration
if [[ "$IS_MAC" == true ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
else
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Set FZF options
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --height=80% \
  --preview-window=right:60% \
  --bind='ctrl-/:toggle-preview' \
  --bind='ctrl-u:preview-half-page-up' \
  --bind='ctrl-d:preview-half-page-down' \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

# Use fd for faster file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Use bat for file preview with syntax highlighting
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {}'
  --bind 'ctrl-/:toggle-preview'
"

# Preview directory contents with eza/ls
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always {} 2>/dev/null || ls -la {}'
"

# Initialize starship prompt (if installed)
command -v starship &>/dev/null && eval "$(starship init zsh)"

# Initialize zoxide (smarter cd, if installed)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"

# Auto-load nvm default version on shell start (if nvm is installed)
if [[ -d "$HOME/.nvm/versions/node" ]]; then
    # Use the default or latest installed version
    NVM_DEFAULT=$(ls -1 "$HOME/.nvm/versions/node" 2>/dev/null | sort -V | tail -1)
    [[ -n "$NVM_DEFAULT" ]] && export PATH="$HOME/.nvm/versions/node/$NVM_DEFAULT/bin:$PATH"
fi
